
import Foundation
import Combine

class WeatherViewModel {

    var address: String
    var cancelled = Set<AnyCancellable>()
    
    init(address: String) {
        self.address = address
        getWeather()
    }
    
    private func getWeather() {
        LocationManager.shared.getCoordinate(addressString: address) { [self] location in
            let weatherManager = WeatherManager(
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude
            )
            
            weatherManager.$stateHourly
                .sink { state in
                    switch state {
                    case .loading:
                        print("loading")
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
                        print("loading")
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

}
