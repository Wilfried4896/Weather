//
//  NavigationBarCustom.swift
//  Weather
//
//  Created by Вилфриэд Оди on 31.01.2023.
//

import UIKit

class NavigationBarCustom: UIButton {
    var actionButton: (() -> Void)?
    
    convenience init(title: String? = nil, type: UIButton.ButtonType = .system ) {
       
        self.init(type: type)
        
        setTitle(title, for: .normal)
        setImage(UIImage(named: "Arrow 2"), for: .normal)
        tintColor = .black
        setTitleColor(.systemGray, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let spacing:CGFloat = 20.0; // the amount of spacing to appear between image and title
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
    }
    
    @objc private func buttonTapped() {
        actionButton?()
    }
}



