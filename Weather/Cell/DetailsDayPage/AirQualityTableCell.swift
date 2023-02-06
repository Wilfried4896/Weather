
import UIKit
import SnapKit

class AirQualityTableCell: UITableViewCell {
    static let shared = "AirQualityTableCell"
    
    lazy var airQualityLabel: UILabel = {
        let airQuality = UILabel()
        airQuality.text = "Качество воздуха"
        airQuality.configurationPrincipeWeather(size: 18, weight: .regular, color: .black)
        return airQuality
    }()
    
    lazy var numberLabel: UILabel = {
        let number = UILabel()
        number.text = "42"
        number.configurationPrincipeWeather(size: 30, weight: .regular, color: .black)
        return number
    }()
    
    lazy var airQualityCommentLabel: UILabel = {
        let airQualityNumber = UILabel()
        airQualityNumber.text = "хорошо"
        airQualityNumber.font = UIFont.systemFont(ofSize: 14)
        airQualityNumber.textColor = .black
        airQualityNumber.layer.borderColor = CGColor(red: 129/255, green: 202/255, blue: 128/255, alpha: 1)
        return airQualityNumber
    }()
    
    lazy var commentLabel: UILabel = {
        let comment = UILabel()
        comment.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        comment.numberOfLines = 0
        comment.text = "Качество воздуха считается удовлетворительным и загрязнения воздуха представляются незначительными в пределах нормы"
        return comment
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurationAirQuality()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationAirQuality() {
        contentView.addSubview(airQualityLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(airQualityCommentLabel)
        contentView.addSubview(commentLabel)
        
        airQualityLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.top.equalTo(airQualityLabel.snp.bottom).offset(10)
        }
        
        airQualityCommentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(numberLabel.snp.centerY)
            make.leading.equalTo(numberLabel.snp.trailing).offset(10)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(10)
            make.bottom.equalTo(contentView).inset(23)
            make.trailing.leading.equalTo(contentView)
        }
    }
}
