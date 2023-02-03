//
//  SearchPageView.swift
//  Weather
//
//  Created by Вилфриэд Оди on 07.01.2023.
//

import UIKit
import SnapKit

class SearchPageView: UIView {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    var weatherData = [DataHours]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(searchBar)
        //print(weatherData.count)
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchPageView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.searchBar.endEditing(true)
        LocationManager.shared.getCoordinate(addressString: searchText) { location in
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=\(latitude)&lon=\(longitude)&hours&hours=24", decodable: WeatherHours.self) { result in
                print(result.data)
            }
        }
    }
}
