//
//  Weather.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
}
