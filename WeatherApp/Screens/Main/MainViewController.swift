//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private var city: City? {
        didSet {
            setupData()
        }
    }
    
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
        
        setupTitle(with: "Wellcome")
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        WeatherService.shared.getWeather(city: "Minsk") { city in
            self.city = city
        }
    }
    
    // MARK: - Private
    private func setupTitle(with text: String) {
        navigationItem.title = text
    }
    
    private func setupNavigationController() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addCityAction))
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
    
    @IBAction func refreshAction(_ sender: UIButton) {
        print("REFRESH")
    }
}

extension MainViewController {
    
    @objc func signOutAction() {
        presentAlert()
    }
    
    @objc func addCityAction() {
        print("ADD CITY")
    }
    
    // MARK: - UIAlertController
    private func presentAlert() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to exit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
          print("Handle Yes logic here")
          }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
