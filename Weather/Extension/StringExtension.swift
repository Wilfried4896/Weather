//
//  StringExtension.swift
//  Weather
//
//  Created by Вилфриэд Оди on 02.12.2022.
//

import UIKit
import CoreData

let userDefaultString = UserDefaults.standard

extension String {
    
    var toTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var time = String()
        let format = dateFormatter.date(from: self)
        switch userDefaultString.bool(forKey: "isEnableTimeFormat") {
        case true:
            dateFormatter.dateFormat = "h:mm a"
            time = dateFormatter.string(from: format!)
        case false:
            dateFormatter.dateFormat = "HH:mm"
            time = dateFormatter.string(from: format!)
        }
        return time
    }
    
    var toDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let format = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd/MM"
        let date = dateFormatter.string(from: format!)
        return date
    }
    
    var toDateFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd:HH"
        let format = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EE dd/MM"
        let date = dateFormatter.string(from: format!)
        return date
    }
    
    var toFullDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let format = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EE dd/MM"
        let date = dateFormatter.string(from: format!)
        return date
    }
    
    var toFullDateHome: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let format = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EE dd MMMM"
        let date = dateFormatter.string(from: format!)
        return date
    }
}


