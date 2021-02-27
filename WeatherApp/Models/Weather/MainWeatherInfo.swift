//
//  MainWeatherInfo.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import Foundation

struct MainWeatherInfo: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
}
