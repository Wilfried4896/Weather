
import UIKit
import SnapKit

class HomeTableCell: UITableViewCell {
    static let shared = "HomeTableCell"
    
    lazy var ellipseIcon: UIImageView = {
        let ellipse = UIImageView()
        ellipse.image = UIImage(named: "Ellipse 3")
        return ellipse
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descrip = UILabel()
        descrip.configurationPrincipeWeather(size: 16, weight: .bold, color: .white)
        return descrip
    }()
    
    lazy var iconImageSunrise: UIImageView = {
        let sunrise = UIImageView()
        sunrise.image = UIImage(systemName: "sunrise")
        sunrise.tintColor = .systemYellow
        return sunrise
    }()
    
    lazy var iconImageSunset: UIImageView = {
        let sunset = UIImageView()
        sunset.image = UIImage(systemName: "sunset")
        sunset.tintColor = .systemYellow
        return sunset
    }()
    
    lazy var sunriseLabel: UILabel = {
        let sunrise = UILabel()
        sunrise.configurationPrincipeWeather(size: 14, weight: .bold, color: .white)
        return sunrise
    }()
    
    lazy var sunsetLabel: UILabel = {
        let sunset = UILabel()
        sunset.configurationPrincipeWeather(size: 14, weight: .bold, color: .white)
        return sunset
    }()
    
    lazy var dateTimeLabel: UILabel = {
        let dateTime = UILabel()
        dateTime.configurationPrincipeWeather(size: 16, weight: .bold, color: .systemYellow)
        return dateTime
    }()
    
    lazy var weatherPrincipeLabel: UILabel = {
        let weatherPrincipe = UILabel()
        weatherPrincipe.configurationPrincipeWeather(size: 36, weight: .medium, color: .white)
        return weatherPrincipe
    }()
    
    lazy var weatherTempLabel: UILabel = {
        let weatherTemp = UILabel()
        weatherTemp.configurationPrincipeWeather(size: 16, weight: .regular, color: .white)
        return weatherTemp
    }()
    
    lazy var numberNolabel: UILabel = {
        let numberNo = UILabel()
        numberNo.configurationPrincipeWeather(size: 14, weight: .bold, color: .white)
        return numberNo
    }()
    
    lazy var numberNoIcon: UIImageView = {
        let numberNo = UIImageView()
        numberNo.image = UIImage(named: "Group")
        numberNo.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(15)
        }
        return numberNo
    }()
    
    lazy var windLabel: UILabel = {
        let wind = UILabel()
        wind.configurationPrincipeWeather(size: 14, weight: .bold, color: .white)
        return wind
    }()
    
    lazy var windIcon: UIImageView = {
        let wind = UIImageView()
        wind.image = UIImage(named: "ветер")?.withRenderingMode(.alwaysTemplate)
        wind.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(15)
        }
        wind.tintColor = .white
        return wind
    }()
    
    lazy var precipitationLabel: UILabel = {
        let precipitation = UILabel()
        precipitation.configurationPrincipeWeather(size: 14, weight: .bold, color: .white)
        return precipitation
    }()
    
    lazy var precipitationIcon: UIImageView = {
        let precipitation = UIImageView()
        precipitation.image = UIImage(named: "Frame 1")?.withRenderingMode(.alwaysTemplate)
        precipitation.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(15)
        }
        precipitation.tintColor = .white
        return precipitation
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurationHomeView()
    }
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationHomeView() {
        contentView.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        contentView.layer.cornerRadius = 10
                
        let stackViewSunrise = UIStackView(arrangedSubviews: [iconImageSunrise, sunriseLabel])
        stackViewSunrise.verticalDetail(5)
        
        let stackViewsunset = UIStackView(arrangedSubviews: [iconImageSunset, sunsetLabel])
        stackViewsunset.verticalDetail(5)
        
        let stackViewLabel = UIStackView(arrangedSubviews: [weatherTempLabel, weatherPrincipeLabel])
        stackViewLabel.verticalDetail(5)
        
        let stackDescripLabel = UIStackView(arrangedSubviews: [stackViewLabel, descriptionLabel])
        stackDescripLabel.verticalDetail(6)
        
        let stackWind = UIStackView(arrangedSubviews: [windIcon, windLabel])
        stackWind.horizontalDetail(4)
        
        let stackPrecipitation = UIStackView(arrangedSubviews: [precipitationIcon, precipitationLabel])
        stackPrecipitation.horizontalDetail(4)
        
        let stacknumberNo = UIStackView(arrangedSubviews: [numberNoIcon, numberNolabel])
        stacknumberNo.horizontalDetail(4)
        
        let groupStack = UIStackView(arrangedSubviews: [stacknumberNo, stackWind, stackPrecipitation])
        groupStack.horizontalDetail(24)
        groupStack.distribution = .equalSpacing
        
        let groupDataTimeStack = UIStackView(arrangedSubviews: [groupStack, dateTimeLabel])
        groupDataTimeStack.verticalDetail(25)
        
        contentView.addSubview(ellipseIcon)
        contentView.addSubview(stackViewSunrise)
        contentView.addSubview(stackViewsunset)
        contentView.addSubview(stackDescripLabel)
        contentView.addSubview(groupDataTimeStack)
        
        ellipseIcon.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(13)
            make.trailing.leading.equalTo(contentView).inset(30)
        }
        
        stackViewSunrise.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(15)
            make.top.equalTo(ellipseIcon.snp.bottom).offset(5)
        }
        
        stackViewsunset.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(12)
            make.top.equalTo(ellipseIcon.snp.bottom).offset(5)
        }

        stackDescripLabel.snp.makeConstraints { make in
            make.top.equalTo(ellipseIcon.snp.bottom).offset(-110)
            make.leading.trailing.equalTo(contentView).inset(58)
        }

        groupDataTimeStack.snp.makeConstraints { make in
            make.top.equalTo(stackDescripLabel.snp.bottom).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView).inset(20)
        }
    }
    
    func setUp(homePageData: Dayly) {
        weatherTempLabel.text = homePageData.min_temp.concervCelcusFahrenheit + "/" + homePageData.max_temp.concervCelcusFahrenheit
        weatherPrincipeLabel.text = homePageData.temp.concervCelcusFahrenheit
        sunriseLabel.text = "\(Double(homePageData.sunrise_ts).toDate)"
        sunsetLabel.text = "\(Double(homePageData.sunset_ts).toDate)"
        windLabel.text = homePageData.wind_spd.conversMileKilometr
        precipitationLabel.text = "\(Int(homePageData.pop.rounded()))%"
        dateTimeLabel.text = "\(Date().dateShort),  \(homePageData.datetime!.toFullDateHome)"
        descriptionLabel.text = homePageData.descriptionIcon
        numberNolabel.text = "\(Int(homePageData.max_dhi.rounded()))"
    }
}

