//
//  User.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/25/21.
//

import Foundation

struct User: Decodable {
    let id: String
    let email: String?
    let cities: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case cities
    }
}
