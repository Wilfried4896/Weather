//

import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String?, titleName: String, color: UIColor) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        if let imageName {
            button.setImage(UIImage(named: imageName), for: .normal)
        } else {
           // button.setImage(UIImage(named: imageName), for: .normal)
        }
        
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(titleName, for: .normal)
        button.tintColor = color
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}
