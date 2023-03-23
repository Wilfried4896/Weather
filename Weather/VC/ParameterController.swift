
import UIKit
import SnapKit

class ParameterController: UIViewController {
    weak var coordinator: HomePageCoordinator?
    let coreDataManager = CoreDataManager()
    let userDefault = UserDefaults.standard
    
    lazy var viewparamatre: UIView = {
        let paramatr = UIView()
        paramatr.backgroundColor = UIColor(red: 233/255, green: 238/255, blue: 250/255, alpha: 1)
        paramatr.layer.cornerRadius = 10
        return paramatr
    }()
    
    lazy var imagesViews: [UIImageView] = {
        var images: [UIImageView] = []
        let imageName = ["Vector-3", "Vector-4", "Vector-3"]
        imageName.forEach {
            let image = UIImage(named: $0)
            let imageview = UIImageView(image: image)
            images.append(imageview)
        }
        return images
    }()
    
    lazy var namePageLabel: UILabel = {
        let namePage = UILabel()
        namePage.configurationLabel("Настройки")
        namePage.textColor = .black
        return namePage
    }()
    
    lazy var weatherSwitch: UISwitch = {
        let weather = UISwitch()
        weather.setOn(userDefault.bool(forKey: "isEnableWeather"), animated: true)
        weather.addTarget(self, action: #selector(didTapWeather), for: .valueChanged)
        weather.onTintColor = .systemBlue
        return weather
    }()
    
    lazy var weatherLabel: UILabel = {
        let weather = UILabel()
        weather.configurationLabel("Температура (°C / °F)")
        return weather
    }()
    
    lazy var windSpeedSwitch: UISwitch = {
        let windSpeed = UISwitch()
        windSpeed.setOn(userDefault.bool(forKey: "isEnableWind"), animated: true)
        windSpeed.addTarget(self, action: #selector(didTapWindSpeed), for: .valueChanged)
        windSpeed.onTintColor = .systemBlue
        return windSpeed
    }()
    
    lazy var windSpeedLabel: UILabel = {
        let windSpeed = UILabel()
        windSpeed.configurationLabel("Скорость ветра (m/s / Mi)")
        return windSpeed
    }()
    
    lazy var timeFormatSwitch: UISwitch = {
        let timeFormat = UISwitch()
        timeFormat.onTintColor = .systemBlue
        timeFormat.setOn(userDefault.bool(forKey: "isEnableTimeFormat"), animated: true)
        timeFormat.addTarget(self, action: #selector(didTapTimeFormat), for: .valueChanged)
        return timeFormat
    }()
    
    lazy var timeFormatLabel: UILabel = {
        let timeFormat = UILabel()
        timeFormat.configurationLabel("Формат времени")
        return timeFormat
    }()
    
    lazy var notificationsSwitch: UISwitch = {
        let notifications = UISwitch()
        notifications.setOn(userDefault.bool(forKey: "isEnableNotification"), animated: true)
        notifications.addTarget(self, action: #selector(didTapNotification), for: .valueChanged)
        notifications.onTintColor = .systemBlue
        return notifications
    }()
    
    lazy var notificationsLabel: UILabel = {
        let notifications = UILabel()
        notifications.configurationLabel("Уведомления")
        return notifications
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationParamatrPage()
    }

    private func configurationParamatrPage() {
        view.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        
        navigationController?.navigationBar.tintColor = .white
        
        let stackWeather = UIStackView(arrangedSubviews: [weatherLabel, weatherSwitch])
        stackWeather.distribution = .equalSpacing
        stackWeather.axis = .horizontal
        
        let stackWindSpeed = UIStackView(arrangedSubviews: [windSpeedLabel, windSpeedSwitch])
        stackWindSpeed.distribution = .equalSpacing
        
        let stackTimeFormat = UIStackView(arrangedSubviews: [timeFormatLabel, timeFormatSwitch])
        stackTimeFormat.distribution = .equalSpacing
        
        let stackNotifications = UIStackView(arrangedSubviews: [notificationsLabel, notificationsSwitch])
        stackNotifications.distribution = .equalSpacing
        
        let groupeStack = UIStackView(arrangedSubviews: [stackWeather, stackWindSpeed, stackTimeFormat, stackNotifications])
        groupeStack.spacing = 25
        groupeStack.axis = .vertical
        
        view.addSubview(viewparamatre)
        viewparamatre.addSubview(namePageLabel)
        viewparamatre.addSubview(groupeStack)
        imagesViews.forEach {
            view.addSubview($0)
        }
        
        //MARK: - viewparamatre
        viewparamatre.snp.makeConstraints { make in
            make.height.equalTo(330)
            make.width.equalTo(320)
            make.centerX.centerY.equalToSuperview()
            make.top.equalTo(imagesViews[0].snp.bottom).offset(24)
        }
        
        
        //MARK: - namePageLabel
        namePageLabel.snp.makeConstraints { make in
            make.leading.equalTo(viewparamatre).inset(20)
            make.top.equalTo(viewparamatre).inset(20)
        }
        
        groupeStack.snp.makeConstraints { make in
            make.leading.equalTo(viewparamatre).inset(20)
            make.top.equalTo(namePageLabel).inset(40)
            make.trailing.equalTo(viewparamatre).inset(40)
        }
        
       
        imagesViews[0].snp.makeConstraints { make in
            make.top.equalTo(view).inset(120)
            make.trailing.equalTo(view).offset(2)
        }
            
        imagesViews[1].snp.makeConstraints { make in
            make.top.equalTo(viewparamatre.snp.bottom).offset(50)
            make.bottom.equalTo(view).inset(94)
            make.leading.trailing.equalTo(view).inset(79)
        }
        
        imagesViews[2].snp.makeConstraints { make in
            make.top.equalTo(view).inset(37)
            make.leading.equalTo(view).offset(2)
        }
    }
    
    @objc private func didTapTimeFormat() {
        guard timeFormatSwitch.isOn else {
            userDefault.set(false, forKey: "isEnableTimeFormat")
            return
        }
        userDefault.set(true, forKey: "isEnableTimeFormat")
    }
    
    @objc private func didTapNotification() {
        guard notificationsSwitch.isOn else {
            userDefault.set(false, forKey: "isEnableNotification")
            return
        }
        userDefault.set(true, forKey: "isEnableNotification")
    }
    
    @objc private func didTapWindSpeed() {
        guard windSpeedSwitch.isOn else {
            userDefault.set(false, forKey: "isEnableWind")
            return
        }
        userDefault.set(true, forKey: "isEnableWind")
    }
    
    @objc private func didTapWeather() {
        guard weatherSwitch.isOn else {
            userDefault.set(false, forKey: "isEnableWeather")
            return
        }
        userDefault.set(true, forKey: "isEnableWeather")
    }
}

