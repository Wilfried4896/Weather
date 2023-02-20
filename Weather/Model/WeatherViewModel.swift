
import Foundation

class WeatherViewModel {
    
    func getWeatherData(_ latitude: Double, _ longitude: Double) {
        WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=\(latitude)&lon=\(longitude)&hours=24",
                                         decodable: WeatherHours.self) { result in
            
            CoreDataManager.shared.saveDataCityWeatherHourly(from: result)
            
        }
       
        WeatherManager.shared.getWeather(urlString: "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=\(latitude)&lon=\(longitude)",
                                         decodable: WeatherDays.self) { result in
            CoreDataManager.shared.saveDataCityWeatherDayly(weatherCityDaily: result)
        }
    }
}
