
import Foundation
import Alamofire

// f7b1c3f286msh769eba7c71bdabdp100fbbjsn94b56fd20a55
// 3627e2b665mshbc179a4b1e75cacp115659jsn98bdc20526d8

class WeatherManager {
    static let shared = WeatherManager()
    
    func getWeather<T: Decodable>(urlString: String, decodable: T.Type, completion: @escaping (T) -> Void) {
        
        guard let url = URL(string: urlString) else {
            print("Error on link")
            return }
    
        let headers = [
            "X-RapidAPI-Key": "3627e2b665mshbc179a4b1e75cacp115659jsn98bdc20526d8",
            "X-RapidAPI-Host": "weatherbit-v1-mashape.p.rapidapi.com"
        ]
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        AF.request(request)
            .responseData { response in
                let jsonData = response.data
                guard let jsonData else { return }
                do {
                    let data = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
}
