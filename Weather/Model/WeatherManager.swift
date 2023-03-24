
import Foundation
import Combine

// f7b1c3f286msh769eba7c71bdabdp100fbbjsn94b56fd20a55
// cc5ac6e99fmsh34a47779a346706p15d5c3jsnf28181f9193b

class WeatherManager {
    
    var cancelled = Set<AnyCancellable>()
    var longitude: Double
    var latitude: Double
    
    enum StateHourly {
        case loading
        case success(weatherHourly: WeatherHours)
        case failed(error: Error)
        case none
    }
    
    enum StateDaily {
        case loading
        case success(weatherDaily: WeatherDays)
        case failed(error: Error)
        case none
    }
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        
        getHourly()
        getDaily()
    }
    
    @Published var stateHourly: StateHourly = .none
    @Published var stateDaily: StateDaily = .none
    
    var hourly: WeatherHours?
    
    private func getHourly() {
        stateHourly = .loading
        
        let urlString = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=\(latitude)&lon=\(longitude)&hours=24"
        
        guard let url = URL(string: urlString) else { return }
    
        let headers = [
            "X-RapidAPI-Key": "f7b1c3f286msh769eba7c71bdabdp100fbbjsn94b56fd20a55",
            "X-RapidAPI-Host": "weatherbit-v1-mashape.p.rapidapi.com"
        ]
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeatherHours.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.stateHourly = .failed(error: error)
                default: break
                }
            } receiveValue: { hourly in
                self.stateHourly = .success(weatherHourly: hourly)
                self.hourly = hourly
            }
            .store(in: &cancelled)
    }
    
   private func getDaily() {
        stateDaily = .loading
        
        let urlString = "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=\(latitude)&lon=\(longitude)"
        
        guard let url = URL(string: urlString) else { return }
    
        let headers = [
            "X-RapidAPI-Key": "f7b1c3f286msh769eba7c71bdabdp100fbbjsn94b56fd20a55",
            "X-RapidAPI-Host": "weatherbit-v1-mashape.p.rapidapi.com"
        ]
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: WeatherDays.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.stateDaily = .failed(error: error)
                default: break
                }
            } receiveValue: { daily in
                self.stateDaily = .success(weatherDaily: daily)
            }
            .store(in: &cancelled)
    }
}


