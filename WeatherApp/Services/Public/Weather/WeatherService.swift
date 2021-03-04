//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import Foundation

final class WeatherService {    
    private let appId = "b86556e258b3dbb75b7f39e114f65b72"
    
    func getWeather(city: String, completion: @escaping(City?)->()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(appId)") else { completion(nil); return }
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else { return completion(nil) }
                let city = try? JSONDecoder().decode(City.self, from: data)
                completion(city)
            }
        }
        task.resume()
    }
}
