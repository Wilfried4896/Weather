
import UIKit
import SnapKit

class DetailDayForecastController: UIViewController {
    weak var coordinator: HomePageCoordinator?
    weak var delegateFromHome: HomePageDelegate?
    
    var indexSelect: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.register(DetailsDayTableCell.self, forCellReuseIdentifier: DetailsDayTableCell.shared)
        tableview.register(DateShowTableCell.self, forCellReuseIdentifier: DateShowTableCell.shared)
        tableview.register(SunMoonTableCell.self, forCellReuseIdentifier: SunMoonTableCell.shared)
        tableview.register(AirQualityTableCell.self, forCellReuseIdentifier: AirQualityTableCell.shared)
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 40
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .systemBackground
        return tableview
    }()
    
    lazy var cityLabel: UILabel = {
        let city = UILabel()
        city.configurationPrincipeWeather(size: 18, weight: .semibold, color: .black)
        return city
    }()
    
    var dataDayH: [DataDays] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationDetailDayForecast()
    }
    
    private func configurationDetailDayForecast() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(cityLabel)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(actionButton), imageName: "Arrow 2", titleName: "\tДневная погода", color: .black)
        
        if let getForBundle = getForBundle() {
            dataDayH = getForBundle.data
            cityLabel.text = getForBundle.city_name
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(view).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.trailing.leading.equalTo(view).inset(15)
            make.bottom.equalTo(view)
        }
    }
    
    private func getForBundle() -> WeatherDays? {
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
    
    @objc private func actionButton() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension DetailDayForecastController: UITableViewDelegate, UITableViewDataSource, DateShowDelegate {
    func indexDelected(indexSelected: IndexPath) {
        indexSelect = indexSelected.row
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateShowTableCell.shared, for: indexPath) as! DateShowTableCell
            cell.delegateShowDetailDay = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsDayTableCell.shared, for: indexPath) as! DetailsDayTableCell
            cell.setUpLow(dataDayLow: dataDayH[indexSelect])
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsDayTableCell.shared, for: indexPath) as! DetailsDayTableCell
            cell.setUpNight(dataDayNigth: dataDayH[indexSelect])
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: SunMoonTableCell.shared, for: indexPath) as! SunMoonTableCell
            cell.setUp(sunMoonData: dataDayH[indexSelect])
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: AirQualityTableCell.shared, for: indexPath) as! AirQualityTableCell
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
    }
}


