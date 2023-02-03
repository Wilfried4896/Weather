//
//  File.swift
//  Weather
//
//  Created by Вилфриэд Оди on 04.12.2022.
//

import UIKit

extension UIStackView {
    func horizontalDetail(_ spac: CGFloat?) {
        axis = .horizontal
        guard let spac else {
            spacing = 0
            return
        }
        spacing = spac
    }
    
    func verticalDetail(_ space: CGFloat?) {
        axis = .vertical
        alignment = .center
        guard let space else {
            spacing = 0
            return
        }
        spacing = space
    }
}
