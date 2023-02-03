//
//  ModelWeather.swift
//  Weather
//
//  Created by Вилфриэд Оди on 30.11.2022.
//

import Foundation

/*
  "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/hourly?lat=38.5&lon=-78.5&hours=24"
  "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/minutely?city=moscou"
  "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/daily?lat=55.75&lon=37.61&units=imperial"
  "https://weatherbit-v1-mashape.p.rapidapi.com/forecast/3hourly?lat=35.5&lon=-78.5&lang=ru"
 */

struct WeatherHours: Codable {
    var city_name: String
    var data: [DataHours]
}

struct WeatherDays: Codable {
    var city_name: String
    var data: [DataDays]
}


struct DataHours: Codable, Identifiable {
    var id = UUID()
    var wind_spd: Double // vitesse du vent
    var rh: Double // relative humidity en %
    var temp: Double // temperature
    var datetime: String
    var app_temp: Double // по ощущению
    var pop: Double // precipitation %
    var timestamp_local: String // heure locale
    var weather: WeatherDescription // description de la tempature
    var precip: Double // precipitation %
    var clouds: Int // % Cloudiness
    
    enum CodingKeys: String, CodingKey {
        case wind_spd
        case rh
        case temp
        case datetime
        case app_temp
        case pop
        case timestamp_local
        case weather
        case precip
        case clouds
    }
}


struct DataDays: Codable {
    var app_max_temp: Double // // feed temp
    var app_min_temp: Double // feed temp
    var wind_spd: Double // vitesse du vent
    var datetime: String // date
    var pop: Double // precipitation %
    var sunrise_ts: Int //
    var sunset_ts: Int //
    var max_temp: Double //
    var clouds: Int //
    var min_temp: Double //
    var high_temp: Double // High Temperature "Day-time High"
    var low_temp: Double // Low Temperature "Night-time Low"
    var rh: Double // relative humidity en %
    var temp: Double // temperature
    var weather: WeatherDescription // description de la tempature
    var precip: Double // precipitation
    var wind_cdir: String // 
    var max_dhi: Double? //
    var moonrise_ts: Int
    var moonset_ts: Int
    var moon_phase_lunation: Double
}

struct WeatherDescription: Codable {
    var icon: String // icon pour les differents temps (dossiers avec les images en png)
    var description: String // description du temps
}
