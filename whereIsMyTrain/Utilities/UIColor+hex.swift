//
//  UIColor+hex.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 10/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgbHex: Int) {
        self.init(
            red: (rgbHex >> 16) & 0xFF,
            green: (rgbHex >> 8) & 0xFF,
            blue: rgbHex & 0xFF
        )
    }
}
