//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func didLogout()
}

class MainViewController: UIViewController {
    
    // MARK: - Constants
    private struct Constants {
        static let cityTableViewCell = "CityTableViewCell"
    }
    
    weak var delegate: MainViewControllerDelegate?
    private var cities = [String]()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cityTableViewCell)
        }
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle(with: "Welcome")
        setupNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.cities = Dependencies.services.userService.user?.cities ?? []
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
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
}

extension MainViewController {
    
    @objc func signOutAction() {
        presentAlert()
    }
    
    @objc func addCityAction() {
        navigationController?.pushViewController(SearchViewController.loadFromNib(), animated: true)
    }
    
    // MARK: - UIAlertController
    private func presentAlert() {
        let alert = UIAlertController(title: "", message: "Are you sure you want to exit?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            Dependencies.services.userService.logout { [weak self] success in
                guard success else { return }
                self?.dismiss(animated: true) {
                    self?.delegate?.didLogout()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityTableViewCell,
                                                 for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        let detailViewController = DetailViewController.loadFromNib()
        detailViewController.configurate(with: city)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = cities[indexPath.row]
            Dependencies.services.userService.removeCity(city)
            self.cities.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
