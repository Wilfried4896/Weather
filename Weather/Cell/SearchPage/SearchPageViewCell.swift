
import UIKit
import SnapKit

class SearchPageViewCell: UICollectionViewCell {
    static let shared = "SearchPageViewCell"
    
    lazy var dayLabel: UILabel = {
        let day = UILabel()
        day.configurationPrincipeWeather(size: 16, weight: .regular, color: .white)
        return day
    }()
    
    lazy var popLabel: UILabel = {
        let pop = UILabel()
        pop.configurationPrincipeWeather(size: 14, weight: .regular, color: .white)
        return pop
    }()
    
    lazy var imagePop: UIImageView = {
        let image = UIImageView()
        image.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        return image
    }()
    
    lazy var tempLabel: UILabel = {
        let temp = UILabel()
        temp.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        return temp
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
        
        let stackTempInformation = UIStackView(arrangedSubviews: [dayLabel, popLabel, imagePop])
        stackTempInformation.verticalDetail(3)
        
        let stackTempInfoTemp = UIStackView(arrangedSubviews: [stackTempInformation, tempLabel])
        stackTempInfoTemp.verticalDetail(7)
        
        contentView.addSubview(stackTempInfoTemp)
   
        stackTempInfoTemp.snp.makeConstraints { make in
            make.trailing.leading.top.bottom.equalTo(contentView)
        }
    }
    
    func setUp(with day: DataDays) {
        dayLabel.text = day.datetime.toDay
        if day.pop == 0 {
            popLabel.text = " "
        } else {
            popLabel.text = "\(Int(day.pop))%"
        }

        imagePop.image = UIImage(named: "\(day.weather.icon)")
        tempLabel.text = day.app_min_temp.concervCelcusFahrenheit + "/" + day.app_max_temp.concervCelcusFahrenheit
    }
}
