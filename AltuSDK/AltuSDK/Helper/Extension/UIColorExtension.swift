//
//  UIColorExtension.swift
//  AltuSDK
//
//  Created by Ricardo Caldeira on 27/03/22.
//

import UIKit

public extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        
        //swiftlint:disable:next identifier_name
        let a, r, g, b: UInt32
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    private convenience init(colorLiteralRed: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: CGFloat(colorLiteralRed), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    @nonobjc convenience init(colorLiteralRed: Int, green: Int, blue: Int, alpha: Float) {
        self.init(colorLiteralRed: Float(colorLiteralRed) / 255.0, green: Float(green) / 255.0, blue: Float(blue) / 255.0, alpha: alpha)
    }
    
    func toHexString() -> String {
                var r:CGFloat = 0
                var g:CGFloat = 0
                var b:CGFloat = 0
                var a:CGFloat = 0

                getRed(&r, green: &g, blue: &b, alpha: &a)

                let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

                return String(format:"#%06x", rgb)
            }
}
