
import UIKit
import SnapKit

class WeatherController: UIViewController {
    
    weak var coordinator: HomePageCoordinator?
    var weather: Weather!
    
    var daily: [Daily] = []
    var hourly: [Hourly] = []
    
    lazy var cityLabel: UILabel = {
        let city = UILabel()
        city.text = UserDefaults.standard.string(forKey: "cityName")
        city.configurationPrincipeWeather(size: 18, weight: .semibold, color: .black)
        return city
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.separatorStyle = .none
        tableview.register(CurrentWeatherCell.self, forCellReuseIdentifier: CurrentWeatherCell.shared)
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
    
    init(weather: Weather) {
        super.init(nibName: nil, bundle: nil)
        
        self.weather = weather
        edgesForExtendedLayout = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(cityLabel)

        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(50)
            make.leading.trailing.equalTo(view).inset(10)
            make.bottom.equalTo(view)
        }

        cityLabel.text = weather.hourly.cityName
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        daily = CoreDataManager.shared.fetchAllDaily(daily: weather.daily)
        hourly = CoreDataManager.shared.fetchAllHourly(hourly: weather.hourly)
        
        tableView.reloadData()
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource, DateShowDelegate, WeatherHourDelegate {
    func indexSelected(indexSelected: IndexPath) {
        let dailyVC = DetailDayForecastController()
        
        if let city = weather.daily.cityName {
            dailyVC.daily = daily
            dailyVC.cityLabel.text = city
            dailyVC.indexSelect = indexSelected
        }
        navigationController?.pushViewController(dailyVC, animated: true)
    }
    
    func showHourlyPage() {
        let hourlyVC = DetailHoursForecastController()
        if let city = weather.hourly.cityName {
            hourlyVC.hourly = hourly
            hourlyVC.cityName = city
        }
        
        navigationController?.pushViewController(hourlyVC, animated: true)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherCell.shared, for: indexPath) as! CurrentWeatherCell
            
            if let currentDaily = daily.first {
                cell.setUp(currentData: currentDaily)
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherHourTableCell.identifier, for: indexPath) as! WeatherHourTableCell
            
            cell.hourly = hourly
            
            cell.delegate = self
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDayTableCell.identifier, for: indexPath) as! WeatherDayTableCell
            
            cell.daily = daily
        
            cell.delegateShowDetailDay = self
            return cell
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as UITableViewCell
        }
    }
}
