
import UIKit
import SnapKit
import CoreLocation

class HomePageController: UIViewController {
    
    weak var coordinator: HomePageCoordinator?
    private var contentView: [UIView] = []
    var locationCordinates: CLLocation?
    let notification = NotificationCenter.default

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var searchPageView: SearchPageView = {
        let searhPage = SearchPageView()
        return searhPage
    }()
    
    lazy var emptyPageView: UIView = {
        let emptyPage = UIView()
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
    
    lazy var locationIcon: UIButton = {
        let location = UIButton()
        location.setImage(UIImage(named: "месторасположение"), for: .normal)
        location.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(20)
        }
        return location
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
        
        if let getWeatherDay = getWeatherDays() {
            dataWeatherDay = getWeatherDay.data
        }
        if let getWeatherHours = getWeatherHour() {
            dataWeatherHour = getWeatherHours.data
        }
        
        notification.addObserver(self, selector: #selector(receivedDataFromNotificationCenter(_:)), name: NSNotification.Name("location"), object: nil)
    }
    
    private func configurationHomePage() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        if locationCordinates != nil {
            contentView = [tableView, searchPageView]
        } else {
            contentView = [emptyPageView, searchPageView]
        }
        
        
        contentView.forEach { view in
            scrollView.addSubview(view)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: locationIcon)
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
    
    private func getWeatherHour() -> WeatherHours? {
        if let url = Bundle.main.path(forResource: "weatherHour", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(filePath: url))
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(WeatherHours.self, from: data)
                    return jsonData
                } catch {
                    print("error:\(error)")
                }
            }
            return nil
    }
    
    private func getWeatherDays() -> WeatherDays? {
        if let url = Bundle.main.path(forResource: "weatherDay", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(filePath: url))
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(WeatherDays.self, from: data)
                    return jsonData
                } catch {
                    print("error:\(error)")
                }
            }
            return nil
    }
    
   @objc private func receivedDataFromNotificationCenter(_ notification: Notification) {
       print(notification.object)
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
