
import SwiftUI
import Charts
import Foundation



struct Contients: View {
    
    var getForBundle: WeatherHours? {
        if let url = Bundle.main.path(forResource: "weatherHour", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(filePath: url))
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(WeatherHours.self, from: data)
                    return jsonData
                } catch {
                    print("error:\(error)")
                }
            }
            return nil
    }
    
    var list: [DataHours] {
        var list: [DataHours] = []
        if let listData = getForBundle?.data {
            for index in 0..<20 {
                list.append(listData[index])
            }
        }
        return list
    }
    
    
    var body: some View {
        VStack() {
            ScrollView(.horizontal) {
                Chart(list) { savingModel in
                    AreaMark(
                        x: .value("", savingModel.timestamp_local.toTime),
                        y: .value("", savingModel.app_temp)
                    )
                    
                }
                .chartXAxis(.automatic)
                .chartYAxis(.hidden)
                
                Chart(list) { savingModel in
                    LineMark(
                        x: .value("", savingModel.timestamp_local.toTime),
                        y: .value("", savingModel.app_temp)
                    )

                    .interpolationMethod(.cardinal)
                    .symbol(Circle())
                }
                
                .chartXAxis(.automatic)
                .chartYAxis(.hidden)
            }
            .padding(20)
            
        }
        .frame(height: 120)
    }
}

