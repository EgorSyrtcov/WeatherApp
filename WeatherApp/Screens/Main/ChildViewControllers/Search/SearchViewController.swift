//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/27/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 22
    }
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var addCityButton: UIButton!
    
    private var city: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupSearchController()
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Search cities"
        addCityButton.layer.cornerRadius = Constants.buttonRadius
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true 
    }
    
    @IBAction func addCityButtonAction(_ sender: UIButton) {
        guard let city = city else { return }

        Dependencies.services.weatherService.getWeather(city: city) { [weak self] city in
            guard let cityString = self?.city else { return }
            if city != nil {
                Dependencies.services.userService.addCity(cityString)
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.presentAlert()
            }
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "No selected city", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentAlertForEnterText() {
        let alert = UIAlertController(title: "Error", message: "Enter the name of the city in English", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        let ruCharacters = "йцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ"
        
        text.forEach { (char) in
            if (ruCharacters.contains(char)) {
                presentAlertForEnterText()
                searchController.searchBar.text?.remove(at: text.firstIndex(of: char)!)
            }
            city = text.capitalizingFirstLetter()
        }
    }
}
