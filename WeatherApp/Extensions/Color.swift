//
//  Color.swift
//  Weater
//
//  Created by Egor Syrtcov on 2/25/21.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func darkGreen() -> UIColor {
        return UIColor(red: 57, green: 162, blue: 148)
    }
    
    static func darkGrey() -> UIColor {
        return UIColor(red: 54, green: 57, blue: 56)
    }
    
    static func disabledBlue() -> UIColor {
        return UIColor(red: 33/255, green: 37/255, blue: 242/255, alpha: 0.1)
    }
    
    static func activeBlue() -> UIColor {
        return UIColor(red: 33, green: 37, blue: 242)
    }
}
