//
//  Dependencies.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/27/21.
//

import Foundation

final class Dependencies {
    static let services = Dependencies()
    let userService = UserService()
    let weatherService = WeatherService()
}
