
import Foundation

class WeatherViewModel {
    let latitude: Double?
    let longitude: Double?

    init(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getWeatherDataHours(completionHandler: @escaping ([DataHours]) -> Void) {
        
        guard let latitude = latitude, let longitude = longitude else { return }
        let urlHour = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=\(latitude)&lon=\(longitude)&hours&hours=24"
        WeatherManager.shared.getWeather(urlString: urlHour, decodable: WeatherHours.self) { result in
            completionHandler(result.data)
        }
    }

    func getWeatherDataDays(completionHandler: @escaping ([DataDays]) -> Void) {
        guard let latitude = latitude, let longitude = longitude else { return }
        let urlDay = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=\(latitude)&lon=\(longitude)&hours"
        WeatherManager.shared.getWeather(urlString: urlDay, decodable: WeatherDays.self) { result in
            completionHandler(result.data)
        }
    }
}
