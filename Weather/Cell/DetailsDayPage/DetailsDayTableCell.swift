
import UIKit
import SnapKit

class DetailsDayTableCell: UITableViewCell {
    static let shared = "DetailsDayTableCell"
    
    lazy var tempLabel: UILabel = {
        let temp = UILabel()
        temp.configurationPrincipeWeather(size: 30, weight: .bold, color: .black)
        return temp
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.configurationPrincipeWeather(size: 18, weight: .regular, color: .black)
        return title
    }()
    
    lazy var tempIcon: UIImageView = {
        let icon = UIImageView()
        icon.snp.makeConstraints { make in
            make.size.equalTo(40)
           // make.width.equalTo(25)
        }
        return icon
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descrip = UILabel()
        descrip.configurationPrincipeWeather(size: 18, weight: .bold, color: .black)
        return descrip
    }()
    
    lazy var feelingLabel: UILabel = {
        let feeling = UILabel()
        feeling.text = "По ощущениям"
        feeling.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return feeling
    }()
    
    lazy var feelingIcon: UIImageView = {
        let icon = UIImageView()
        icon.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
        icon.image = UIImage(named: "Frame-1")
        return icon
    }()
    
    lazy var windLabel: UILabel = {
        let wind = UILabel()
        wind.text = "Ветер"
        wind.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return wind
    }()
    
    lazy var windIcon: UIImageView = {
        let icon = UIImageView()
        icon.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(17)
        }
        icon.image = UIImage(named: "ветер")
        return icon
    }()
    
    lazy var sunLabel: UILabel = {
        let sun = UILabel()
        sun.text = "Уф индекс"
        sun.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return sun
    }()
    
    lazy var sunIcon: UIImageView = {
        let icon = UIImageView()
        icon.snp.makeConstraints { make in
            make.size.equalTo(25)
        }
        icon.image = UIImage(named: "Vector-2")
        return icon
    }()
    
    lazy var rainLabel: UILabel = {
        let rain = UILabel()
        rain.text = "Дождь"
        rain.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return rain
    }()
    
    lazy var rainIcon: UIImageView = {
        let icon = UIImageView()
        icon.snp.makeConstraints { make in
            make.size.equalTo(25)
           // make.height.equalTo(17)
        }
        icon.image = UIImage(named: "Frame-2")
        return icon
    }()
    
    lazy var precipetationLabel: UILabel = {
        let precipetation = UILabel()
        precipetation.text = "Облачность"
        precipetation.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return precipetation
    }()
    
    lazy var precipetationIcon: UIImageView = {
        let icon = UIImageView()
        icon.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(17)
        }
        icon.image = UIImage(named: "Frame-3")
        return icon
    }()
    
    lazy var feelingValueLabel: UILabel = {
        let feelingValue = UILabel()
        feelingValue.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return feelingValue
    }()
    
    lazy var windValueLabel: UILabel = {
        let windValue = UILabel()
        windValue.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return windValue
    }()
    
    lazy var sunValueLabel: UILabel = {
        let sunValue = UILabel()
        sunValue.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return sunValue
    }()
    
    lazy var rainValueLabel: UILabel = {
        let rainValue = UILabel()
        rainValue.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return rainValue
    }()
    
    lazy var precipetationValueLabel: UILabel = {
        let precipetationValue = UILabel()
        precipetationValue.configurationPrincipeWeather(size: 14, weight: .regular, color: .black)
        return precipetationValue
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurationDatailsDayTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurationDatailsDayTable() {
        contentView.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        contentView.layer.cornerRadius = 10
        
        let spacingBetweenIconWind = CGFloat(10)
        
        //MARK: - UIStackView between Icon and Label
        let stackTempIcon = UIStackView(arrangedSubviews: [tempIcon, tempLabel])
        stackTempIcon.horizontalDetail(spacingBetweenIconWind)
        
        let stackWind = UIStackView(arrangedSubviews: [windIcon, windLabel])
        stackWind.horizontalDetail(spacingBetweenIconWind)
        
        let stackRain = UIStackView(arrangedSubviews: [rainIcon, rainLabel])
        stackRain.horizontalDetail(spacingBetweenIconWind)
        
        let stackSun = UIStackView(arrangedSubviews: [sunIcon, sunLabel])
        stackSun.horizontalDetail(spacingBetweenIconWind)
        
        let stackFeel = UIStackView(arrangedSubviews: [feelingIcon, feelingLabel])
        stackFeel.horizontalDetail(spacingBetweenIconWind)
        
        let stackPrecipetation = UIStackView(arrangedSubviews: [precipetationIcon, precipetationLabel])
        stackPrecipetation.horizontalDetail(spacingBetweenIconWind)
        
        
        //MARK: - UIStackView between (Icon and Label) and Value
        let stackTempStakDescription = UIStackView(arrangedSubviews: [stackTempIcon, descriptionLabel])
        stackTempStakDescription.verticalDetail(10)
        
        let stackValeurWind = UIStackView(arrangedSubviews: [stackWind, windValueLabel])
        stackValeurWind.distribution = .equalSpacing
        
        let stackValeurFeel = UIStackView(arrangedSubviews: [stackFeel, feelingValueLabel])
        stackValeurFeel.distribution = .equalSpacing
        
        let stackValeurSun = UIStackView(arrangedSubviews: [stackSun, sunValueLabel])
        stackValeurSun.distribution = .equalSpacing
        
        let stackValeurRain = UIStackView(arrangedSubviews: [stackRain, rainValueLabel])
        stackValeurRain.distribution = .equalSpacing
        
        let stackValeurPrecipetation = UIStackView(arrangedSubviews: [stackPrecipetation, precipetationValueLabel])
        stackValeurPrecipetation.distribution = .equalSpacing
        
        //MARK: - UIStackView groupe
        let groupStack = UIStackView(arrangedSubviews: [stackValeurWind, stackValeurSun, stackValeurFeel, stackValeurRain, stackValeurPrecipetation])
        groupStack.axis = .vertical
        groupStack.spacing = 20
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackTempStakDescription)
        contentView.addSubview(groupStack)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(21)
            make.leading.equalTo(contentView).inset(12)
        }
        
        stackTempStakDescription.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(15)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        groupStack.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(12)
            make.leading.trailing.equalTo(contentView).inset(15)
            make.top.equalTo(stackTempStakDescription.snp.bottom).offset(28)
        }
    }
    
    func setUpLow(dataDayLow: Daily) {
        titleLabel.text = "День"
        feelingValueLabel.text = dataDayLow.max_temp.concervCelcusFahrenheit
        tempIcon.image = UIImage(named: dataDayLow.icon ?? "")
        tempLabel.text = dataDayLow.high_temp.concervCelcusFahrenheit
        descriptionLabel.text = dataDayLow.descriptionIcon
        windValueLabel.text = dataDayLow.wind_spd.conversMileKilometr + " " + dataDayLow.wind_cdir!
     
        sunValueLabel.text = "\(Int(dataDayLow.max_dhi.rounded()))"
    
        rainValueLabel.text = "\(Int(dataDayLow.pop.rounded()))%"
        precipetationValueLabel.text = "\(dataDayLow.clouds)%"
    }
    
    func setUpNight(dataDayNigth: Daily) {
        titleLabel.text = "Ночь"
        feelingValueLabel.text = dataDayNigth.app_min_temp.concervCelcusFahrenheit
        tempIcon.image = UIImage(named: dataDayNigth.icon ?? "")
        tempLabel.text = dataDayNigth.low_temp.concervCelcusFahrenheit
        descriptionLabel.text = dataDayNigth.descriptionIcon
        windValueLabel.text = dataDayNigth.wind_spd.conversMileKilometr + " " + dataDayNigth.wind_cdir!
        
        sunValueLabel.text = "\(Int(dataDayNigth.max_dhi.rounded()))"
      
        rainValueLabel.text = "\(Int(dataDayNigth.pop.rounded()))%"
        precipetationValueLabel.text = "\(dataDayNigth.clouds)%"
    }
}
