//
//  SignUpViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var delegate: AuthDelegate?
    
    enum ButtonState {
        case loading
        case disabled
        case active
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let buttonRadius: CGFloat = 22
    }
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var registerButton: UIButton!
    
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
                registerButton.setTitle("Enter login and password", for: .normal)
                registerButton.backgroundColor = UIColor.disabledBlue()
                registerButton.isEnabled = false
            case .active:
                loginSpinner.stopAnimating()
                registerButton.setTitle("Create", for: .normal)
                registerButton.backgroundColor = UIColor.activeBlue()
                registerButton.isEnabled = true
            case .loading:
                registerButton.setTitle("", for: .normal)
                loginSpinner.startAnimating()
                registerButton.backgroundColor = UIColor.activeBlue()
                registerButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }
    
    private func setupView() {
        setupTitle(with: "Register")
        emailField.setup(with: "Email", message: "enter your email")
        emailField.textDidChanged = textFieldDidBeginEditing
        passwordField.setup(with: "Password", message: "enter your password (аt least 8 digits)", keyboardType: .numberPad)
        passwordField.textDidChanged = textFieldDidBeginEditing
        
        registerButton.layer.cornerRadius = Constants.buttonRadius
        
        registerButton.addSubview(loginSpinner)
        loginButtonState = .disabled
        loginSpinner.centerXAnchor.constraint(equalTo: registerButton.centerXAnchor).isActive = true
        loginSpinner.centerYAnchor.constraint(equalTo: registerButton.centerYAnchor).isActive = true
    }
    
    private func setupTitle(with text: String) {
        navigationItem.title = text
    }
    
    private func clearTextFields() {
        emailField.text = ""
        passwordField.text = ""
    }
    
    private func textFieldDidBeginEditing() {
        loginButtonState = emailField.text.isValidString(for: .email) && passwordField.text.isValidString(for: .password) ? .active : .disabled
    }
    
    @IBAction func registerActionButton() {
        loginButtonState = .loading
        
        Dependencies.services.userService.singup(credential: Credential.init(email: emailField.text, password: passwordField.text)) { [weak self] user in
            if user == nil {
                self?.presentAlert()
            } else {
                self?.dismiss(animated: true, completion: { [weak self] in
                    self?.delegate?.didSuccess()
                })
            }
        }
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
