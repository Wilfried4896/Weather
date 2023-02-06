
import SwiftUI
import Charts
import Foundation



struct Contients: View {
    var getForBundle: [DataHours] {
            if let url = Bundle.main.path(forResource: "weatherHour", ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(filePath: url))
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(WeatherHours.self, from: data)
                        return jsonData.data
                    } catch {
                        print("error:\(error)")
                    }
                }
                return []
        }
    
    
    
    var body: some View {
        var listData = Array(getForBundle.prefix(10))
        let curColor = Color(hue: 0.33, saturation: 0.81, brightness: 0.76)
        let curGradient = LinearGradient(
            gradient: Gradient (
                colors: [
                    curColor.opacity(0.5),
                    curColor.opacity(0.2),
                    curColor.opacity(0.05),
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        
        VStack() {
            Chart {
                ForEach(listData) { list in
                    LineMark(
                        x: .value("", list.timestamp_local.toTime),
                        y: .value("", list.app_temp.concervCelcusFahrenheit)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .symbolSize(20)
                    
                    PointMark(x: .value("", list.timestamp_local.toTime),
                              y: .value("", list.app_temp.concervCelcusFahrenheit)
                    )
                    .annotation {
                        Text("\(list.app_temp.concervCelcusFahrenheit)")
                            .font(.custom("", size: 10))
                    }
                    .symbol() {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 5)
                    }
                   
                    AreaMark(x: .value("", list.timestamp_local.toTime),
                              y: .value("", list.app_temp.concervCelcusFahrenheit)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(curGradient)
                }
            }
            .padding(.top, 30)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            Chart {
                ForEach(listData) { list in
                    LineMark(x: .value("", list.timestamp_local.toTime),
                             y: .value("", list.app_temp)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    
                    PointMark(
                        x: .value("", list.timestamp_local.toTime),
                        y: .value("", list.app_temp)
                    )
                    .annotation(content: {
                        VStack(spacing: 0) {
                            Image(list.weather.icon)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(Int(list.pop))%")
                                .font(.custom("", size: 10))
                        }
                    })
                    .symbol() {
                        Rectangle()
                            .frame(width: 4, height: 8)
                            .foregroundColor(Color.blue)
                    }
                }
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks { mark in
                    AxisValueLabel()
                        .font(.custom("RubikRoman-Regular", size: 9))
                        .foregroundStyle(.black)
                }
            }
        }
        .frame(height: 130)
        .padding(.bottom, 15)
        .padding(.top, 10)
    }
}
