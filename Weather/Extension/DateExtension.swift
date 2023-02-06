
import UIKit

let userDefaultDate = UserDefaults.standard

extension Date {
    var dateShort: String {
        let dateFormate = DateFormatter()
        var time = ""
        switch userDefaultDate.bool(forKey: "isEnableTimeFormat") {
        case true:
            dateFormate.dateFormat = "h:mm a"
            time = dateFormate.string(from: self)
        case false:
            dateFormate.dateFormat = "HH:mm"
            time = dateFormate.string(from: self)
        }
        return time
    }
}
