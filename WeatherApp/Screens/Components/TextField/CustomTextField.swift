//
//  CustomTextField.swift
//  WeatherApp
//
//  Created by Egor Syrtcov on 2/26/21.
//

import UIKit

class CustomTextField: NibLoadingView, UITextFieldDelegate {
    
    enum State: Equatable {
        case active
        case unactive
        case error(String)
    }
    
    // MARK: - Properties
    
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textFieldCustom: UITextField!
    @IBOutlet private weak var bottomLineView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    var state: State = .unactive {
        didSet {
            changeState()
        }
    }
    
    var text: String {
        get {
            return textFieldCustom.text ?? ""
        }
        set {
            textFieldCustom.text = newValue
        }
    }
    
    var textDidChanged: (() -> Void)?
    
    // MARK: - View life cycle
    
    override func becomeFirstResponder() -> Bool {
        textFieldCustom.becomeFirstResponder()
        return true
    }
    
    // MARK: - Public
    
    func setup(with placeholder: String, message: String, keyboardType: UIKeyboardType = .default) {
        placeholderLabel.text = placeholder
        messageLabel.text = message
        textFieldCustom.delegate = self
        textFieldCustom.keyboardType = keyboardType
    }
    
    // MARK: - Private
    
    private func changeState() {
        var fieldColor: UIColor = .darkGreen()
        var messageColor: UIColor = .darkGrey()
        
        switch state {
        case .active:
            fieldColor = .darkGreen()
        case .unactive:
            fieldColor = .darkGrey()
        case .error(let message):
            fieldColor = .darkGreen()
            messageLabel.text = message
            messageColor = .red
        }
        messageLabel.textColor = messageColor
        bottomLineView.backgroundColor = fieldColor
        placeholderLabel.textColor = fieldColor
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        state = textField.isEditing ? .active : .unactive
        textDidChanged?()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textDidChanged?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        state = textField.isEditing ? .active : .unactive
    }
}
