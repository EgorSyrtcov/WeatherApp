//
//  CustomTextField.swift
//  Weater
//
//  Created by Egor Syrtcov on 2/24/21.
//
//

import UIKit

extension String {
    
    func isBlank() -> Bool {
        let newString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newString.isEmpty
    }
    
    private func isEmail() -> Bool {
        let emailRegex = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    private func isPasswordValid() -> Bool {
        let passwordRegex = "\\d{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES[c] %@", passwordRegex)
        return passwordTest.evaluate(with: self)
    }
    
    private func isRegularValid() -> Bool {
        let newString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newString.count >= 2
    }
    
    func isValidString(for field: TypeField) -> Bool {
        switch field {
        case .email:
            return isEmail()
        case .password:
            return isPasswordValid()
        case .regular:
            return isRegularValid()
        }
    }
}

enum TypeField {
    case email
    case password
    case regular
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
