//
//  WeatherHourTableCell.swift
//  Weather
//
//  Created by Вилфриэд Оди on 03.12.2022.
//

import UIKit
import SnapKit

protocol WeatherHourDelegate: AnyObject {
    func didTapInfo()
}

class WeatherHourTableCell: UITableViewCell {
    static let identifier = "WeatherHourTableCell"
    weak var delegate: WeatherHourDelegate?
    
    var dataWeatherHour = [DataHours]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var moreInfoHourLabel: UIButton = {
        let moreInfoHour = UIButton(type: .system)
        moreInfoHour.setTitle("Подробнее на 24 часа", for: .normal)
        moreInfoHour.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        moreInfoHour.setTitleColor(.black, for: .normal)
        moreInfoHour.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
        return moreInfoHour
    }()
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
//        viewLayout.minimumInteritemSpacing = 5
        viewLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(WeatherHoursCell.self, forCellWithReuseIdentifier: WeatherHoursCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(moreInfoHourLabel)
        
        if let getForBundle = getForBundle() {
            dataWeatherHour = getForBundle.data
        }
        
        moreInfoHourLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(moreInfoHourLabel.snp.bottom).offset(15)
            make.bottom.trailing.leading.equalTo(contentView)
            make.height.equalTo(100)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc func didTapMoreInfo() {
        delegate?.didTapInfo()
    }
    
}

extension WeatherHourTableCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHoursCell.identifier, for: indexPath) as! WeatherHoursCell
        cell.layer.cornerRadius = 22
        cell.setUp(hour: dataWeatherHour[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
}
