
import UIKit
import SnapKit
import SwiftUI

class DetailHoursForecastController: UIViewController {
    weak var coordinator: HomePageCoordinator?
    
    var hourly: [Hourly] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var cityName: String = ""
    
    lazy var cityLabel: UILabel = {
        let city = UILabel()
        city.text = UserDefaults.standard.string(forKey: "cityName")
        city.configurationPrincipeWeather(size: 18, weight: .semibold, color: .black)
        return city
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DetailByHourMoreInfoTableCell.self, forCellReuseIdentifier: DetailByHourMoreInfoTableCell.shared)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationDetailHoursForecast()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

    private func configurationDetailHoursForecast() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(actionButton), imageName: "Arrow 2", titleName: "\tПрогноз на 24 часа", color: .black)
        
        let controller = UIHostingController(rootView: Contients(weatherHourly: hourly))
        guard let charts = controller.view else { return }
        charts.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        
        view.addSubview(charts)
        view.addSubview(tableView)
        view.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view).inset(60)
        }
        
        charts.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(15)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(140)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(charts.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        cityLabel.text = cityName
    }
 
    @objc private func actionButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailHoursForecastController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourly.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailByHourMoreInfoTableCell.shared, for: indexPath) as! DetailByHourMoreInfoTableCell
        cell.setUp(hourDescprition: hourly[indexPath.row])
        return cell
    }
}

