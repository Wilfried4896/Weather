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
    var currentSelected: IndexPath?
    weak var delegateShowDetailDay: DateShowDelegate?
    private let notification = NotificationCenter.default
    
    var dataWeatherDay: [DataDays] = []
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.minimumInteritemSpacing = 10
        viewLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        notification.addObserver(self, selector: #selector(indexPathFromHomeVC(_:)), name: Notification.Name("indexPath"), object: nil)
        
        contentView.addSubview(collectionView)
        
        if let getForBundle = getForBundle() {
            dataWeatherDay = getForBundle.data
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(contentView)
            make.height.equalTo(55)
        }
    }
    
    @objc func indexPathFromHomeVC(_ notification: Notification) {
       
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

extension DateShowTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataWeatherDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
        
        cell.backgroundColor = currentSelected?.item == indexPath.item ? .systemBlue : .white
        cell.dateLabel.textColor = currentSelected?.item == indexPath.item ? .white : .black
        cell.layer.cornerRadius = 10
        
        cell.setUp(date: dataWeatherDay[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelected = indexPath
        if let currentSelected {
            delegateShowDetailDay?.indexDelected(indexSelected: currentSelected)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 50)
    }
}
