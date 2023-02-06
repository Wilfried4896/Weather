
import Foundation

let userDefaults = UserDefaults.standard

extension Double {
    var toDate: String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        var time = ""
        switch userDefaults.bool(forKey: "isEnableTimeFormat") {
        case true:
            dateFormatter.dateFormat = "h:mm a"
            time = dateFormatter.string(from: date)
        case false:
            dateFormatter.dateFormat = "HH:mm"
            time = dateFormatter.string(from: date)
        }
        return time
    }
    
    var toHour: String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        var hours = ""
        switch userDefaults.bool(forKey: "isEnableTimeFormat") {
        case true:
            dateFormatter.dateFormat = "h"
            hours = dateFormatter.string(from: date)
        case false:
            dateFormatter.dateFormat = "HH"
            hours = dateFormatter.string(from: date)
        }
        return hours
    }
    
    var toMinute: String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: date)
    }
    
    var concervCelcusFahrenheit: String {
        let celcus = self
        let conversToFahrenheit = (celcus * 9 / 5) + 35
        var fahrenheit = ""
        
        switch userDefaults.bool(forKey: "isEnableWeather") {
        case true:
            fahrenheit = String(Int(conversToFahrenheit.rounded())) + "°"
        case false:
            fahrenheit = String(Int(celcus.rounded())) + "°"
        }
        return fahrenheit
    }
    
    var conversMileKilometr: String {
        let metre = self
        let conversMileToKilometre = metre / 1_609.344
        var result = ""
        
        switch userDefaults.bool(forKey: "isEnableWind") {
        case true:
            result = String(conversMileToKilometre.rounded()) + " Mi"
        case false:
            result = String(Int(metre.rounded())) + " m/s"
        }
        return result
    }
}
