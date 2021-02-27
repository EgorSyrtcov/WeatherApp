//
//  User.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/25/21.
//

import Foundation

class User: Decodable {
    let id: String
    let email: String?
    private(set) var cities: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case cities
    }
    
    init(id: String, email: String?, cities: [String]) {
        self.id = id
        self.email = email
        self.cities = cities
    }
    
    func addCity(_ city: String) {
        cities.append(city)
    }
    
    func removeCity(_ city: String) {
        guard let index = cities.map({ $0.lowercased() }).firstIndex(of: city.lowercased()) else { return }
        cities.remove(at: index)
    }
    
}
