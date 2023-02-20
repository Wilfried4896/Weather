
import UIKit
import SnapKit
import CoreData

class HomePageController: UIViewController {
    
    weak var coordinator: HomePageCoordinator?
    private var contentView: [UIView] = []
    private let viewModel = WeatherViewModel()
    
    let currentValue = 0
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    lazy var searchPageViewView: SearchPageView = {
        let search = SearchPageView()
        return search
    }()
    
    lazy var emptyPageView: EmptyPageView = {
        let emptyPage = EmptyPageView()
        return emptyPage
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.separatorStyle = .none
        tableview.register(HomeTableCell.self, forCellReuseIdentifier: HomeTableCell.shared)
        tableview.register(WeatherHourTableCell.self, forCellReuseIdentifier: WeatherHourTableCell.identifier)
        tableview.register(WeatherDayTableCell.self, forCellReuseIdentifier: WeatherDayTableCell.identifier)
        tableview.estimatedRowHeight = 40
        tableview.showsVerticalScrollIndicator = false
        tableview.rowHeight = UITableView.automaticDimension
        tableview.delegate = self
        tableview.dataSource = self
        tableview.allowsSelection = false
        tableview.backgroundColor = .systemBackground
        return tableview
    }()
    
    let fetchControllerDaily: NSFetchedResultsController<WeatherCityDaily> = {
        let fetchResquest = NSFetchRequest<WeatherCityDaily>(entityName: "WeatherCityDaily")
        fetchResquest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchResquest.fetchLimit = 1
        let frc = NSFetchedResultsController(
            fetchRequest: fetchResquest,
            managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return frc
    }()
    
    var dataWeatherHour = [Hourly]()
    
    lazy var pageControler: UIPageControl = {
        let pageControler = UIPageControl()
        pageControler.pageIndicatorTintColor = .systemGray
        pageControler.currentPageIndicatorTintColor = .black
        pageControler.currentPage = 0
        return pageControler
    }()

    lazy var parameterIcon: UIButton = {
        let parameter = UIButton()
        parameter.setImage(UIImage(named: "бургер"), for: .normal)
        parameter.addTarget(self, action: #selector(didTapParametr), for: .touchUpInside)
        parameter.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        return parameter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationHomePage()
     
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if fetchControllerDaily.fetchedObjects != nil {
            
//        } else {
//            contentView = [emptyPageView, searchPageViewView]
//        }
        
        do {
            try fetchControllerDaily.performFetch()
            fetchControllerDaily.delegate = self
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configurationHomePage() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        contentView = [tableView, searchPageViewView]
        contentView.forEach { view in
            scrollView.addSubview(view)
        }
        
        let addCity = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCity))
        addCity.tintColor = .black
        navigationItem.rightBarButtonItem = addCity
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: parameterIcon)
        
        pageControler.numberOfPages = contentView.count
        view.addSubview(pageControler)
        
        pageControler.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(pageControler.snp.bottom)
            make.leading.trailing.equalTo(view).inset(10)
            make.bottom.equalTo(view)
        }
        
        for (index, uiview) in contentView.enumerated() {
            uiview.snp.makeConstraints { make in
                make.top.bottom.equalTo(scrollView)
                make.width.equalTo(scrollView.snp.width).multipliedBy(1.0)
                make.height.equalTo(scrollView.snp.height).multipliedBy(1.0)
            }
            
            if index == 0 {
                uiview.snp.makeConstraints { make in
                    make.leading.equalTo(scrollView)
                    make.trailing.equalTo(contentView[index + 1].snp.leading)
                }
                continue
            }
            
            if index == contentView.count - 1 {
                uiview.snp.makeConstraints { make in
                    make.leading.equalTo(contentView[index - 1].snp.trailing)
                    make.trailing.equalTo(scrollView.snp.trailing)
                }
                continue
            }
            
            uiview.snp.makeConstraints { make in
                make.leading.equalTo(contentView[index - 1].snp.trailing)
                make.trailing.equalTo(contentView[index + 1].snp.leading)
            }
        }
    }
    
    @objc private func addNewCity() {
        let alert = UIAlertController(title: "Add new city", message: "Do you want to add city", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New city"
        }
        let addAction = UIAlertAction(title: "Search", style: .default) { _ in
            guard let text = alert.textFields?[0].text else { return }
            LocationManager.shared.getCoordinate(addressString: text) { [weak self] location in
                print(location.coordinate)
                self?.viewModel.getWeatherData(location.coordinate.latitude, location.coordinate.longitude)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension HomePageController: UIScrollViewDelegate, NSFetchedResultsControllerDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / view.frame.size.width)
        pageControler.currentPage = Int(pageNumber)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
    
    func indexDelected(indexSelected: IndexPath) {
        coordinator?.indexPathSelect(indexS: indexSelected)
    }

    @objc private func didTapParametr() {
        coordinator?.paramatrPage()
    }
}

extension HomePageController: UITableViewDelegate, UITableViewDataSource, DateShowDelegate, WeatherHourDelegate {
    
    func didTapInfo() {
        coordinator?.detailDay()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return fetchControllerDaily.sections?[0].numberOfObjects ?? 0
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.shared, for: indexPath) as! HomeTableCell
            let weatherCurrent = fetchControllerDaily.object(at: indexPath)
            UserDefaults.standard.set(weatherCurrent.title, forKey: "cityName")
            navigationItem.title = weatherCurrent.title
            let weatherDaily = (weatherCurrent.daily?.allObjects as! [Dayly]).sorted(by: { $0.datetime! < $1.datetime! })
            if let daily = weatherDaily.first {
                 cell.setUp(homePageData: daily)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHourTableCell.identifier, for: indexPath) as! WeatherHourTableCell
            
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayTableCell.identifier, for: indexPath) as! WeatherDayTableCell
            cell.delegateShowDetailDay = self
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as UITableViewCell
        }
    }
}
