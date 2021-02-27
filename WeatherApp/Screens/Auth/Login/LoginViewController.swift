//
//  LoginViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    enum ButtonState {
        case loading
        case disabled
        case active
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 22
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    private let loginSpinner: UIActivityIndicatorView = {
        let loginSpinner = UIActivityIndicatorView(style: .medium)
        loginSpinner.color = .white
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    private var loginButtonState: ButtonState = .disabled {
        didSet {
            switch loginButtonState {
            case .disabled:
                loginSpinner.stopAnimating()
                loginButton.setTitle("Enter login and password", for: .normal)
                loginButton.backgroundColor = UIColor.disabledBlue()
                loginButton.isEnabled = false
                signInButton.backgroundColor = UIColor.activeBlue()
            case .active:
                loginSpinner.stopAnimating()
                loginButton.setTitle("Next", for: .normal)
                loginButton.backgroundColor = UIColor.activeBlue()
                loginButton.isEnabled = true
                signInButton.backgroundColor = UIColor.activeBlue()
            case .loading:
                loginButton.setTitle("", for: .normal)
                loginSpinner.startAnimating()
                loginButton.backgroundColor = UIColor.activeBlue()
                loginButton.isEnabled = false
                signInButton.backgroundColor = UIColor.activeBlue()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupTitle(with: "Login")
        emailField.setup(with: "Email", message: "")
        emailField.textDidChanged = textFieldDidBeginEditing
        passwordField.setup(with: "Password", message: "", keyboardType: .numberPad)
        passwordField.textDidChanged = textFieldDidBeginEditing
        
        loginButton.layer.cornerRadius = Constants.buttonRadius
        signInButton.layer.cornerRadius = Constants.buttonRadius
        
        loginButton.addSubview(loginSpinner)
        loginButtonState = .disabled
        loginSpinner.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        loginSpinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    private func textFieldDidBeginEditing() {
        loginButtonState = emailField.text.isValidString(for: .email) && passwordField.text.isValidString(for: .password) ? .active : .disabled
    }
    
    private func setupTitle(with text: String, textColor: UIColor = .blue, fontSize: CGFloat = 18) {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = textColor
        navigationItem.title = text
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        UserService.shared.login(credential: Credential(email: emailField.text, password: passwordField.text)) { [weak self] (user) in
            
            if user == nil {
                self?.presentAlert()
            } else {
                self?.navigationController?.pushViewController(MainViewController.loadFromNib(), animated: true)
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpViewController.loadFromNib(), animated: true)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}