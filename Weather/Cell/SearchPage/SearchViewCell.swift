
import UIKit
import SnapKit

class SearchViewCell: UICollectionViewCell {
    static let shared = "SearchViewCell"
    
    var searchPageViewCell = [DataDays]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var imageWeather: UIImageView = {
        let image = UIImageView()
        image.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        return image
    }()
    
    lazy var labelWeather: UILabel = {
        let label = UILabel()
        label.configurationPrincipeWeather(size: 30, weight: .regular, color: .white)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.configurationPrincipeWeather(size: 14, weight: .regular, color: .white)
        return description
    }()
    
    lazy var cityLabel: UILabel = {
        let city = UILabel()
        city.configurationPrincipeWeather(size: 14, weight: .regular, color: .white)
        return city
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(SearchPageViewCell.self, forCellWithReuseIdentifier: SearchPageViewCell.shared)
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        contentView.layer.cornerRadius = 15
        let stackTemp = UIStackView(arrangedSubviews: [labelWeather, imageWeather])
        stackTemp.horizontalDetail(6)
        
        let stackDescription = UIStackView(arrangedSubviews: [descriptionLabel, cityLabel])
        stackDescription.verticalDetail(5)
        
        contentView.addSubview(stackTemp)
        contentView.addSubview(stackDescription)
        contentView.addSubview(collectionView)
        
        stackTemp.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(21)
            make.leading.equalTo(contentView).inset(10)
        }
        
        stackDescription.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(30)
            make.trailing.equalTo(contentView).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackTemp.snp.bottom).offset(30)
            make.trailing.leading.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(20)
            make.height.equalTo(80)
        }
    }
    
    func setUp(with dataDays: [WeatherDays]) {
        dataDays.forEach { weatherDays in
            cityLabel.text = weatherDays.city_name
            imageWeather.image = UIImage(named: weatherDays.data[0].weather.icon)
            labelWeather.text = weatherDays.data[0].temp.concervCelcusFahrenheit
            descriptionLabel.text = weatherDays.data[0].weather.descriptionIcon
        }
    }
}

extension SearchViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPageViewCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPageViewCell.shared, for: indexPath) as! SearchPageViewCell
        
        cell.setUp(with: searchPageViewCell[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 80)
    }
}
