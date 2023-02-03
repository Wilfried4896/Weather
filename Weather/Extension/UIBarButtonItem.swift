//
//  UIBarButtonItem.swift
//  Weather
//
//  Created by Вилфриэд Оди on 02.02.2023.
//

import UIKit

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String, titleName: String) -> UIBarButtonItem {
                
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(titleName, for: .normal)
        button.tintColor = .black
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        //menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
//        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        return menuBarItem
    }
}
