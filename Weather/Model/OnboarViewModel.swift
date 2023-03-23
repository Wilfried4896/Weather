
import Foundation
import Combine
import CoreLocation

class OnboarViewModel {

    var longitude: Double = 0
    var latitude: Double = 0
    
    var weatherManager: WeatherManager!
    
    var cancelled = Set<AnyCancellable>()
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.longitude = latitude
        
        getWeather()
    }
    
    private func getWeather() {
        weatherManager = WeatherManager(longitude: longitude, latitude: latitude)
            
        weatherManager.$stateHourly
            .sink { state in
                switch state {
                case .loading:
                    print("")
                case .success(weatherHourly: let weatherHourly):
                    CoreDataManager.shared.saveDataCityWeatherHourly(from: weatherHourly)
                case .failed(error: let error):
                    print(error)
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
        
        weatherManager.$stateDaily
            .sink { state in
                switch state {
                case .loading:
                    print("")
                case .success(weatherDaily: let weatherDaily):
                    CoreDataManager.shared.saveDataCityWeatherDaily(weatherDaily: weatherDaily)
                case .failed(error: let error):
                    print(error)
                case .none:
                    break
                }
            }
            .store(in: &cancelled)
        
    }
}
