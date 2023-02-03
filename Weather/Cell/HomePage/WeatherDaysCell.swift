//
//  WeatherDaysCell.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

import UIKit
import SnapKit

class WeatherDaysCell: UICollectionViewCell {
    static let identifier = "WeatherDaysCell"

    lazy var dayLabel: UILabel = {
        let day = UILabel()
        day.configurationPrincipeWeather(size: 16, weight: .regular, color: .systemGray)
        return day
    }()
    
    lazy var imageIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var humidityLabel: UILabel = {
        let weather = UILabel()
        weather.configurationPrincipeWeather(size: 12, weight: .regular, color: .systemBlue)
        return weather
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
        return description
    }()
    
    lazy var weatherMaxMinLabel: UILabel = {
        let weatherMaxMin = UILabel()
        weatherMaxMin.configurationPrincipeWeather(size: 18, weight: .regular, color: .black)
        return weatherMaxMin
    }()
    
    lazy var iconDirection: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "chevron.right")
        icon.tintColor = .black
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurationWeatherDays()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationWeatherDays() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(imageIcon)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(weatherMaxMinLabel)
        contentView.addSubview(iconDirection)
        
        //MARK: - dayLabel
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.leading.equalTo(contentView).inset(10)
        }
        
        //MARK: - imageIcon
        imageIcon.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView).inset(9)
            make.top.equalTo(dayLabel.snp.bottom).inset(3)
            make.size.equalTo(20)
        }
        
        //MARK: - humidityLabel
        humidityLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageIcon.snp.trailing).offset(5)
            make.bottom.equalTo(contentView).inset(9)
        }
        
        //MARK: - descriptionLabel
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(humidityLabel.snp.trailing).offset(20)
            make.top.bottom.equalTo(contentView).inset(14)
        }
        
        //MARK: - weatherMaxMinLabel
        weatherMaxMinLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(iconDirection.snp.leading).offset(-10)
        }

        iconDirection.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
    
    func setUpCell(day: DataDays) {
        dayLabel.text = day.datetime.toDate
        imageIcon.image = UIImage(named: day.weather.icon)
        humidityLabel.text = "\(Int(day.rh))%"
        descriptionLabel.text = day.weather.description
        weatherMaxMinLabel.text = day.low_temp.concervCelcusFahrenheit + " " +  day.high_temp.concervCelcusFahrenheit
    }
}
