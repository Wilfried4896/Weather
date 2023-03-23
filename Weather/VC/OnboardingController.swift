
import UIKit
import SnapKit
import CoreLocation

class OnboardingController: UIViewController {
    weak var coordinator: OnboardingCoordinator?

    let type = CLLocationManager()
    private var viewModel: OnboarViewModel!
   
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "onb")
        return image
    }()
    
    lazy var firstTextLabel: UILabel = {
        let firstText = UILabel()
        firstText.configurationLabelOnboarding(size: 16, weight: .semibold)
        firstText.text = "Разрешить приложению  Weather использовать данные \nо местоположении вашего устройства"
        return firstText
    }()
    
    lazy var secondTextLabel: UILabel = {
        let secondText = UILabel()
        secondText.configurationLabelOnboarding(size: 14, weight: .regular)
        secondText.text = "Чтобы получить более точные прогнозы погоды во время движения или путешествия"
        return secondText
    }()
    
    lazy var thirdTextLabel: UILabel = {
        let thirdText = UILabel()
        thirdText.configurationLabelOnboarding(size: 14, weight: .regular)
        thirdText.text = "Вы можете изменить свой выбор в любое время из меню приложения"
        return thirdText
    }()
    
    lazy var usedLocalizationBotton: UIButton = {
        let usedLocalization = UIButton(type: .system)
        usedLocalization.setTitle("ИСПОЛЬЗОВАТЬ МЕСТОПОЛОЖЕНИЕ УСТРОЙСТВА", for: .normal)
        usedLocalization.backgroundColor = UIColor(red: 242/255, green: 110/255, blue: 18/255, alpha: 1)
        usedLocalization.setTitleColor(.white, for: .normal)
        usedLocalization.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        usedLocalization.layer.cornerRadius = 10
        usedLocalization.addTarget(self, action: #selector(didTapLocalization), for: .touchUpInside)
        return usedLocalization
    }()
    
    lazy var dontUserLocalizationBotton: UIButton = {
        let dontUserLocalization = UIButton(type: .system)
        dontUserLocalization.setTitle("НЕТ, Я БУДУ ДОБАВЛЯТЬ ЛОКАЦИИ", for: .normal)
        dontUserLocalization.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        dontUserLocalization.setTitleColor(.white, for: .normal)
        dontUserLocalization.addTarget(self, action: #selector(didTapDontUserLocalization), for: .touchUpInside)
        return dontUserLocalization
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationOnboarding()
    }
    
    private func configurationOnboarding() {
        view.backgroundColor = UIColor(red: 32/255, green: 78/255, blue: 199/255, alpha: 1)
        view.addSubview(imageView)
        view.addSubview(firstTextLabel)
        view.addSubview(secondTextLabel)
        view.addSubview(thirdTextLabel)
        view.addSubview(usedLocalizationBotton)
        view.addSubview(dontUserLocalizationBotton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.centerX.equalTo(view)
            make.size.equalTo(180)
        }
        
        // MARK: firstTextLabel
        firstTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(26)
            make.top.equalTo(imageView.snp.bottom).offset(50)
        }
                
        //MARK: secondTextLabel
        secondTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(30)
            make.top.equalTo(firstTextLabel.snp.bottom).offset(40)
        }
        
        //MARK: thirdTextLabel
        thirdTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(30)
            make.top.equalTo(secondTextLabel.snp.bottom).offset(14)
        }
        
        //MARK: usedLocalizationBotton
        usedLocalizationBotton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(thirdTextLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(18)
        }
        
        //MARK: dontUserLocalizationBotton
        dontUserLocalizationBotton.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(18)
            make.top.equalTo(usedLocalizationBotton.snp.bottom).offset(20)
        }
    }
    
    @objc func didTapLocalization() {
        UserDefaults.standard.set(true, forKey: "isConnected")
        LocationManager.shared.getUserLocation {[weak self] location in
            guard let strongeSelf = self else { return }
            DispatchQueue.main.async {
                switch strongeSelf.type.authorizationStatus {
                case .restricted, .denied, .notDetermined: break
                   
                case .authorizedAlways, .authorizedWhenInUse:
                    strongeSelf.viewModel = OnboarViewModel(longitude: location.coordinate.longitude,
                                                            latitude: location.coordinate.latitude)
                @unknown default:
                    fatalError()
                }
            }
            strongeSelf.coordinator?.parent?.homeCoordinator()
        }
    }
    
   
    @objc func didTapDontUserLocalization() {
        UserDefaults.standard.set(true, forKey: "isConnected")
        coordinator?.parent?.homeCoordinator()
    }
}

