//
//  DateShowTableCell.swift
//  Weather
//
//  Created by Вилфриэд Оди on 06.12.2022.
//

import UIKit
import SnapKit

protocol DateShowDelegate: AnyObject {
    func indexDelected(indexSelected: IndexPath)
}

class DateShowTableCell: UITableViewCell {
    static let shared = "DateShowTableCell"
    
    weak var delegateShowDetailDay: DateShowDelegate?
    
    var dataWeatherDay: [DataDays] = []
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.minimumInteritemSpacing = 10
        viewLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        
        if let getForBundle = getForBundle() {
            dataWeatherDay = getForBundle.data
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(contentView)
            make.height.equalTo(55)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}

extension DateShowTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataWeatherDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
        cell.setUp(date: dataWeatherDay[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemGray3
        backgroundView.layer.cornerRadius = 10
        
        if delegateShowDetailDay != nil, let cell = collectionView.cellForItem(at: indexPath) as? DateCell {
            delegateShowDetailDay?.indexDelected(indexSelected: indexPath)
            cell.selectedBackgroundView = backgroundView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 50)
    }
}
