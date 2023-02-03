//
//  DetailByHourMoreInfoTableCell.swift
//  Weather
//
//  Created by Вилфриэд Оди on 04.12.2022.
//

import UIKit
import SnapKit

class DetailByHourMoreInfoTableCell: UITableViewCell {
    static let shared = "DetailByHourMoreInfoTableCell"
    
    lazy var lineIcon: UIImageView = {
        let line = UIImageView()
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        line.image = UIImage(named: "Line 2")
        return line
    }()
    
    lazy var dateTimeLabel: UILabel = {
        let dateTime = UILabel()
        dateTime.configurationPrincipeWeather(size: 18, weight: .medium, color: .black)
        return dateTime
    }()
    
    lazy var hourLabel: UILabel = {
        let hour = UILabel()
        hour.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        return hour
    }()
    
    lazy var tempLabel: UILabel = {
        let temp = UILabel()
        temp.configurationPrincipeWeather(size: 18, weight: .medium, color: .black)
        return temp
    }()
    
    lazy var feelingLabel: UILabel = {
        let feeling = UILabel()
        feeling.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return feeling
    }()
    
    lazy var feelingIcon: UIImageView = {
        let feeling = UIImageView()
        feeling.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        feeling.image = UIImage(named: "crescent-moon 1")
        return feeling
    }()
    
    lazy var windLabel: UILabel = {
        let wind = UILabel()
        wind.text = "Ветер"
        wind.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return wind
    }()
    
    lazy var windIcon: UIImageView = {
        let wind = UIImageView()
        wind.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(17)
        }
        wind.image = UIImage(named: "ветер")
        return wind
    }()
    
    lazy var precipitationLabel: UILabel = {
        let precipitation = UILabel()
        precipitation.text = "Атмосферные осадки"
        precipitation.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return precipitation
    }()
    
    lazy var precipitationIcon: UIImageView = {
        let precipitation = UIImageView()
        precipitation.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(20)
        }
        precipitation.image = UIImage(named: "Frame 1")
        return precipitation
    }()
    
    lazy var cloudinessLabel: UILabel = {
        let cloudiness = UILabel()
        cloudiness.text = "Облачность"
        cloudiness.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return cloudiness
    }()
    
    lazy var cloudinessIcon: UIImageView = {
        let cloudiness = UIImageView()
        cloudiness.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(15)
        }
        cloudiness.image = UIImage(named: "Vector")
        return cloudiness
    }()
    
    lazy var windValeurLabel: UILabel = {
        let windValeur = UILabel()
        windValeur.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        return windValeur
    }()
    
    lazy var cloudinessValeurLabel: UILabel = {
        let cloudinessValeur = UILabel()
        cloudinessValeur.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        return cloudinessValeur
    }()
    
    lazy var precipitationValeurLabel: UILabel = {
        let precipitationValeur = UILabel()
        precipitationValeur.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        return precipitationValeur
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurationDetailByHourMoreInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationDetailByHourMoreInfo() {
        contentView.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        
        let spacing = CGFloat(6)
        let stackViewWind = UIStackView(arrangedSubviews: [windIcon, windLabel])
        stackViewWind.horizontalDetail(spacing)
        let stackViewPrecipitation = UIStackView(arrangedSubviews: [precipitationIcon, precipitationLabel])
        stackViewPrecipitation.horizontalDetail(spacing)
        let stackViewCloudiness = UIStackView(arrangedSubviews: [cloudinessIcon, cloudinessLabel])
        stackViewCloudiness.horizontalDetail(spacing)
        let stackViewFeeling = UIStackView(arrangedSubviews: [feelingIcon, feelingLabel])
        stackViewFeeling.horizontalDetail(spacing)
        
        let stackWind = UIStackView(arrangedSubviews: [stackViewWind, windValeurLabel])
        stackViewWind.horizontalDetail(nil)
        let stackPrecipitation = UIStackView(arrangedSubviews: [stackViewPrecipitation, precipitationValeurLabel])
        stackPrecipitation.horizontalDetail(nil)
        let stackCloudiness = UIStackView(arrangedSubviews: [stackViewCloudiness, cloudinessValeurLabel])
        stackCloudiness.horizontalDetail(nil)
        
        let generalStack = UIStackView(arrangedSubviews: [stackViewFeeling, stackWind, stackPrecipitation, stackCloudiness])
        generalStack.axis = .vertical
        generalStack.spacing = 10
        
        contentView.addSubview(generalStack)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(hourLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(lineIcon)
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(16)
            make.leading.equalTo(contentView).inset(16)
        }
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(8)
            make.leading.equalTo(contentView).inset(16)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(hourLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView).inset(22)
        }
        
        generalStack.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(85)
            make.trailing.equalTo(contentView).inset(15)
            make.top.equalTo(dateTimeLabel.snp.bottom).offset(8)
        }
        
        lineIcon.snp.makeConstraints { make in
            make.top.equalTo(generalStack.snp.bottom).offset(13)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView)
        }
    }
    
    func setUp(hourDescprition: DataHours) {
        feelingLabel.text = "Преимуществен..по ощущению \(hourDescprition.temp.concervCelcusFahrenheit)"
        dateTimeLabel.text = hourDescprition.datetime.toDateFull
        hourLabel.text = hourDescprition.timestamp_local.toTime
        tempLabel.text = hourDescprition.temp.concervCelcusFahrenheit
        windValeurLabel.text = hourDescprition.wind_spd.conversMileKilometr
        precipitationValeurLabel.text = "\(Int(hourDescprition.pop.rounded()))%"
        cloudinessValeurLabel.text = "\(hourDescprition.clouds)%"
    }
}
