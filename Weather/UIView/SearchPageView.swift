
import UIKit
import SnapKit

class SearchPageView: UIView {

    var weatherDay = [WeatherDays]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
//        viewLayout.minimumInteritemSpacing = 5
        viewLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(SearchViewCell.self, forCellWithReuseIdentifier: SearchViewCell.shared)
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(searchBar)
        addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func getWeatherDays() -> WeatherDays? {
//        if let url = Bundle.main.path(forResource: "weatherDay", ofType: "json") {
//                do {
//                    let data = try Data(contentsOf: URL(filePath: url))
//                    let decoder = JSONDecoder()
//                    let jsonData = try decoder.decode(WeatherDays.self, from: data)
//                    return jsonData
//                } catch {
//                    print("error:\(error)")
//                }
//            }
//            return nil
//    }
}
extension SearchPageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if weatherDay.isEmpty {
            let cellEmpty = UICollectionViewCell()
            return cellEmpty
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.shared, for: indexPath) as! SearchViewCell
            cell.searchPageViewCell = weatherDay[indexPath.item].data
            cell.setUp(with: weatherDay)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 207)
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
