
import UIKit
import SnapKit

class WeatherDayTableCell: UITableViewCell {
    static let identifier = "WeatherDayTableCell"
    weak var delegateShowDetailDay: DateShowDelegate?

    var daily: [Daily] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var forecastLabel: UILabel = {
        let forecast = UILabel()
        forecast.text = "Ежедневный прогноз"
        forecast.configurationPrincipeWeather(size: 18, weight: .bold, color: .black)
        return forecast
    }()
    
    lazy var moreInfoDayLabel: UIButton = {
        let moreInfoHour = UIButton(type: .system)
        moreInfoHour.setTitle("16 дней", for: .normal)
        moreInfoHour.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        moreInfoHour.setTitleColor(.black, for: .normal)
       // moreInfoHour.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
        return moreInfoHour
    }()
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
//        viewLayout.minimumLineSpacing = 8
        viewLayout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        viewLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(WeatherDaysCell.self, forCellWithReuseIdentifier: WeatherDaysCell.identifier)
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [forecastLabel, moreInfoDayLabel])
        stackView.horizontalDetail(nil)
        
        contentView.addSubview(collectionView)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(contentView).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.trailing.leading.bottom.equalTo(contentView)
            make.height.equalTo(600)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeatherDayTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherDaysCell.identifier, for: indexPath) as! WeatherDaysCell
        cell.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        cell.layer.cornerRadius = 10
        
        cell.setUpCell(day: daily[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateShowDetailDay?.indexSelected(indexSelected: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: 60)
    }
}

