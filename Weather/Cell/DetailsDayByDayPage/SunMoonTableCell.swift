//
//  SunMoonTableCell.swift
//  Weather
//
//  Created by Вилфриэд Оди on 07.12.2022.
//

import UIKit
import SnapKit

class SunMoonTableCell: UITableViewCell {
    static let shared = "SunMoonTableCell"
    
    lazy var sunMoonLabel: UILabel = {
        let sunMoon = UILabel()
        sunMoon.text = "Солнце и Луна"
        sunMoon.configurationPrincipeWeather(size: 18, weight: .regular, color: .black)
        return sunMoon
    }()
    
    lazy var sepatatorIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Line 7")
        return icon
    }()
    
    lazy var sunIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Vector-2")
        icon.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        return icon
    }()
    
    lazy var sunTimeLabel: UILabel = {
       let suntime = UILabel()
        suntime.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
       return suntime
    }()
    
    lazy var sunSunriseLabel: UILabel = {
        let sunSunrise = UILabel()
        sunSunrise.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        sunSunrise.text = "Восход"
        return sunSunrise
    }()
    
    lazy var sunSunsetLabel: UILabel = {
        let sunSunset = UILabel()
        sunSunset.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        sunSunset.text = "Заход"
        return sunSunset
    }()
    
    lazy var moonIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "crescent-moon 1")
        icon.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        return icon
    }()
    
    lazy var moonTimeLabel: UILabel = {
        let moonTime = UILabel()
        moonTime.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
        return moonTime
    }()
    
    lazy var moonSunriseLabel: UILabel = {
        let moonSunrise = UILabel()
        moonSunrise.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        moonSunrise.text = "Восход"
        return moonSunrise
    }()
    
    lazy var moonSunsetLabel: UILabel = {
        let moonSunset = UILabel()
        moonSunset.configurationPrincipeWeather(size: 14, weight: .regular, color: .systemGray)
        moonSunset.text = "Заход"
        return moonSunset
    }()
    
    lazy var sunSunriseValueLabel: UILabel = {
        let sunSunrise = UILabel()
        sunSunrise.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
        return sunSunrise
    }()
    
    lazy var sunSunsetValueLabel: UILabel = {
        let sunSunset = UILabel()
        sunSunset.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
        return sunSunset
    }()
    
    lazy var moonSunriseValueLabel: UILabel = {
        let moonSunrise = UILabel()
        moonSunrise.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
        return moonSunrise
    }()
    
    lazy var moonSunsetValueLabel: UILabel = {
        let moonSunset = UILabel()
        moonSunset.configurationPrincipeWeather(size: 16, weight: .regular, color: .black)
        return moonSunset
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurationTableCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationTableCell() {
        //MARK: - Icon and TimeLabel
        let stackSunIconLabel = UIStackView(arrangedSubviews: [sunIcon, sunTimeLabel])
        stackSunIconLabel.axis = .horizontal
        stackSunIconLabel.distribution = .equalSpacing
        
        let stackMoonIconLabel = UIStackView(arrangedSubviews: [moonIcon, moonTimeLabel])
        stackMoonIconLabel.axis = .horizontal
        stackMoonIconLabel.distribution = .equalSpacing
        
        //MARK: - Label and ValeurLabel
        let stackSunLabelValeurSunrise = UIStackView(arrangedSubviews: [sunSunriseLabel, sunSunriseValueLabel])
        stackSunLabelValeurSunrise.axis = .horizontal
        stackSunLabelValeurSunrise.distribution = .equalSpacing
        
        let stackMoonLabelValeurSunrise = UIStackView(arrangedSubviews: [moonSunriseLabel, moonSunriseValueLabel])
        stackMoonLabelValeurSunrise.axis = .horizontal
        stackMoonLabelValeurSunrise.distribution = .equalSpacing
        
        let stackSunLabelValeurSunset = UIStackView(arrangedSubviews: [sunSunsetLabel, sunSunsetValueLabel])
        stackSunLabelValeurSunset.axis = .horizontal
        stackSunLabelValeurSunset.distribution = .equalSpacing
        
        let stackMoonLabelValeurSunset = UIStackView(arrangedSubviews: [moonSunsetLabel, moonSunsetValueLabel])
        stackMoonLabelValeurSunset.axis = .horizontal
        stackMoonLabelValeurSunset.distribution = .equalSpacing
        
        let stackSun = UIStackView(arrangedSubviews: [stackSunIconLabel, stackSunLabelValeurSunrise, stackSunLabelValeurSunset])
        stackSun.axis = .vertical
        stackSun.spacing = 20
        
        let stackMoon = UIStackView(arrangedSubviews: [stackMoonIconLabel, stackMoonLabelValeurSunrise, stackMoonLabelValeurSunset])
        stackMoon.axis = .vertical
        stackMoon.spacing = 20
        
        contentView.addSubview(sunMoonLabel)
        contentView.addSubview(sepatatorIcon)
        contentView.addSubview(stackSun)
        contentView.addSubview(stackMoon)
        
        sunMoonLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
        }
        
        sepatatorIcon.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(2)
            make.height.equalTo(105)
            make.top.equalTo(contentView).offset(40)
            make.bottom.equalTo(contentView).inset(10)
        }
        
        stackSun.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(45)
            make.leading.equalTo(contentView).inset(15)
            make.trailing.equalTo(sepatatorIcon.snp.leading).offset(-17)
        }
        
        stackMoon.snp.makeConstraints { make in
            make.top.equalTo(sunMoonLabel.snp.bottom).offset(20)
            make.trailing.equalTo(contentView).inset(5)
            make.leading.equalTo(sepatatorIcon.snp.trailing).offset(24)
        }
    }
    
    func setUp(sunMoonData: DataDays) {
        let differenceTimeSun = Double(sunMoonData.sunset_ts - sunMoonData.sunrise_ts)
        let differenceTimeMoon = Double(sunMoonData.moonset_ts - sunMoonData.moonrise_ts)

        sunTimeLabel.text = "\(differenceTimeSun.toHour)ч \(differenceTimeSun.toMinute) мн"
        moonTimeLabel.text = "\(differenceTimeMoon.toHour)ч \(differenceTimeMoon.toMinute) мн"
        sunSunriseValueLabel.text = "\(Double(sunMoonData.sunrise_ts).toDate)"
        sunSunsetValueLabel.text = "\(Double(sunMoonData.sunset_ts).toDate)"
        moonSunriseValueLabel.text = "\(Double(sunMoonData.moonrise_ts).toDate)"
        moonSunsetValueLabel.text = "\(Double(sunMoonData.moonset_ts).toDate)"
    }
}
