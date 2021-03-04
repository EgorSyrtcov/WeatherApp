//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/27/21.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, MKLocalSearchCompleterDelegate {
    
    // MARK: - Constants
    private struct Constants {
        static let searchTableViewCell = "SearchViewControllerCell"
        static let textCountSearch = 3
    }
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.searchTableViewCell)
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupSearchController()
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Search cities"
        searchCompleter.delegate = self
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true 
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        guard text.count >= Constants.textCountSearch else { return }
        searchCompleter.queryFragment = text
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        searchResults = completer.results
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchTableViewCell,
                                                 for: indexPath)
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
        
            guard let name = response?.mapItems[0].name else {
                return
            }
            self.getCityRequest(city: name)
        }
    }
    
    private func getCityRequest(city: String) {
        Dependencies.services.weatherService.getWeather(city: city) { [weak self] city in
            
            guard let city = city?.name else { self?.presentAlertForEnterText(); return }
                Dependencies.services.userService.addCity(city)
                self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func presentAlertForEnterText() {
        let alert = UIAlertController(title: "Error", message: "Please, select another CITY", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

