//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/27/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var city: City? {
        didSet {
            setupData()
        }
    }
    
    private var cityReguest: String?
    
    // MARK: - Properties
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let cityReguest = cityReguest else { return }
        Dependencies.services.weatherService.getWeather(city: cityReguest) { [weak self] city in
            self?.city = city
        }
    }
    
    private func setupData() {
        guard let city = city else { return }
        cityLabel.text = city.name
        weatherImage.image = UIImage(named: "\(city.weather[0].main)")
        maxTempLabel.text = "Max \(city.main.tempMax)˚C"
        minTempLabel.text = "Min \(city.main.tempMin)˚C"
        tempLabel.text = "\(city.main.temp)˚C"
        feelLikeLabel.text = "Feel like: \(city.main.feelsLike)˚C"
    }
    
    func configurate(with city: String) {
        self.cityReguest = city
    }
}


