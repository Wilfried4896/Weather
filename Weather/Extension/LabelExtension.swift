
import UIKit

extension UILabel {
    
    func configurationLabel(_ name: String) {
        textColor = .systemGray
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text = name
    }
    
    func configurationLabelOnboarding(size: CGFloat, weight: UIFont.Weight) {
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textAlignment = .center
        numberOfLines = 0
        textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    func configurationPrincipeWeather(size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        font = UIFont.systemFont(ofSize: size, weight: weight)
        textColor = color
    }
}
