//
//  WeatherDayCell.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

import UIKit
import SnapKit

class WeatherHoursCell: UICollectionViewCell {
    static let identifier = "WeatherHoursCell"
    
    lazy var timeLabel: UILabel = {
        let time = UILabel()
        time.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        time.textColor = .black
        return time
    }()
    
    lazy var imageIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var weatherLabel: UILabel = {
        let weather = UILabel()
        weather.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        weather.textColor = .black
        return weather
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationWeatherDay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configurationWeatherDay() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(imageIcon)
        contentView.addSubview(weatherLabel)
        
        //MARK: - timeLabel
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(10)
            make.centerX.equalTo(contentView)
        }

        //MARK: - imageIcon
        imageIcon.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.centerX.equalTo(contentView)
            make.size.equalTo(40)
        }

        //MARK: - weatherLabel
        weatherLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(5)
        }
    }
    
    func setUp(hour: DataHours) {
        timeLabel.text = hour.timestamp_local.toTime
        imageIcon.image = UIImage(named: hour.weather.icon)
        weatherLabel.text = hour.temp.concervCelcusFahrenheit
    }
}
