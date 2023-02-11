
import UIKit
import SnapKit
import CoreData

class HomePageController: UIViewController {
    
    weak var coordinator: HomePageCoordinator?
    private var contentView: [UIView] = []
    var locationCordinates: [Double]?
    let notification = NotificationCenter.default
    var weatherHours: WeatherHours?
    var weatherDay: WeatherDays?
    var weatherSearch: [WeatherDays]?
//    var latitude: Double
//    var longitude: Double

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
    
    var dataWeatherDay = [DataDays]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var dataWeatherHour = [DataHours]()
    
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
    
//    init(latitude: Double, longitude: Double) {
//        self.latitude = latitude
//        self.longitude = longitude
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CoreDataManager.shared.weatherCity)
        configurationHomePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let weatherDay, let weatherSearch {
            dataWeatherDay = weatherDay.data
            navigationItem.title = weatherDay.city_name
            searchPageViewView.weatherDay = weatherSearch
        }

        if let weatherHours {
            dataWeatherHour = weatherHours.data
        }
    }
    
    private func configurationHomePage() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        if let locationCordinates = locationCordinates {
            WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=\(locationCordinates[0])&lon=\(locationCordinates[1])&hours&hours=24", decodable: WeatherHours.self) { result in
                self.weatherHours = result
                //print(result.data)
            }
            WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=\(locationCordinates[0])&lon=\(locationCordinates[1])&hours", decodable: WeatherDays.self) { result in
                self.weatherDay = result
                self.weatherSearch?.append(result)
                //print(result.data)
            }
            contentView = [tableView, searchPageViewView]
        } else {
            contentView = [emptyPageView, searchPageViewView]
        }
        
        contentView.forEach { view in
            scrollView.addSubview(view)
        }
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationIcon)
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
            let textField = text
            LocationManager.shared.getCoordinate(addressString: textField) { location in
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print(location.coordinate)
                WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=\(latitude)&lon=\(longitude)&hours&hours=24", decodable: WeatherHours.self) { result in
                    self.weatherHours = result
                    //print(result.data)
                }
                WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=\(latitude)&lon=\(longitude)&hours", decodable: WeatherDays.self) { result in
                    self.weatherDay = result
                   // print(self.weatherDay?.city_name)
                    self.weatherSearch?.append(result)
                    //print(result.data)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension HomePageController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / view.frame.size.width)
        pageControler.currentPage = Int(pageNumber)
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
            return 1
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
            cell.setUp(homePageData: dataWeatherDay[0])
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHourTableCell.identifier, for: indexPath) as! WeatherHourTableCell
            cell.dataWeatherHour = dataWeatherHour
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayTableCell.identifier, for: indexPath) as! WeatherDayTableCell
            cell.delegateShowDetailDay = self
            cell.dataWeatherDay = dataWeatherDay
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as UITableViewCell
        }
    }
}
