//
//  LoginViewController.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

class LoginViewController: UIViewController {
    
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
    
    // MARK: - Properties
    
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        registerForKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTextFields()
    }
    
    deinit {
        removeForKeyboardNotification()
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
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func clearTextFields() {
        emailField.text = ""
        passwordField.text = ""
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
        
        Dependencies.services.userService.login(credential: Credential(email: emailField.text, password: passwordField.text)) { [weak self] (user) in
            
            if user == nil {
                self?.presentAlert()
            } else {
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.didSuccess()
                })
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let signUpViewController = SignUpViewController.loadFromNib()
        signUpViewController.delegate = self
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: AuthDelegate {
    func didSuccess() {
        self.delegate?.didSuccess()
    }
}

extension LoginViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
                return
            }
            let keyboardFrame = scrollView.convert(keyboardFrameValue.cgRectValue, from: nil)
            scrollView.contentOffset = CGPoint(x:0, y:keyboardFrame.size.height)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = .zero
    }
}
