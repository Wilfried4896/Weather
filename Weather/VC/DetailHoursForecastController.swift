
import UIKit
import SnapKit
import SwiftUI

class DetailHoursForecastController: UIViewController {
    weak var coordinator: HomePageCoordinator?
    
    var dataHour: [DataHours] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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
        
        if let getForBundle = getForBundle() {
            dataHour = getForBundle.data
        }
    }

    private func configurationDetailHoursForecast() {
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(actionButton), imageName: "Arrow 2", titleName: "\tПрогноз на 24 часа", color: .black)
        
        let controller = UIHostingController(rootView: Contients())
        guard let charts = controller.view else { return }
        charts.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        
        view.addSubview(charts)
        view.addSubview(tableView)
        
        charts.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(140)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(charts.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        
    }
 
    @objc private func actionButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func getForBundle() -> WeatherHours? {
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

}

extension DetailHoursForecastController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHour.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailByHourMoreInfoTableCell.shared, for: indexPath) as! DetailByHourMoreInfoTableCell

        cell.setUp(hourDescprition: dataHour[indexPath.row])
        return cell
    }
}

