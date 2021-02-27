//
//  ListCitiesViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

final class ListCitiesViewController: UIViewController {
    
    // MARK: - Constants
    private struct Constants {
        static let cityTableViewCell = "CityTableViewCell"
    }
    
    private let arrayCities = [Town(name: "Minsk"),
                               Town(name:"Gomel"),
                               Town(name:"Grodno"),
                               Town(name:"Moscow"),
                               Town(name: "Vitebsk"),
                               Town(name: "Mogilev"),
                               Town(name: "Brest")]
    
    private var filteredCity = [Town]()
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cityTableViewCell)
        }
    }
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupSearchController()
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Search cities"
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ListCitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering == true ? filteredCity.count : arrayCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityTableViewCell,
                                                       for: indexPath)
        var town: Town
        town = isFiltering == true ? filteredCity[indexPath.row] : arrayCities[indexPath.row]
        
        cell.textLabel?.text = town.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var town: Town
        town = isFiltering == true ? filteredCity[indexPath.row] : arrayCities[indexPath.row]
        
        print(town.name)
    }
}

extension ListCitiesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCity = arrayCities.filter {return $0.name.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }
}
