//
//  City.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import Foundation

struct City: Decodable {
    let name: String
    let weather: [Weather]
    let main: MainWeatherInfo
    
    enum CodingKeys: String, CodingKey {
        case name
        case weather
        case main
    }
}
