//
//  UIFontExtension.swift
//  AudioGuide
//
//  Created by Sergej Bekker on 01.02.2022.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
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
}

extension UIFont {
    
    class func PoppinsFont(ofSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "Poppins-Regular", size: ofSize)!
        case .bold:
            return UIFont(name: "Poppins-Bold", size: ofSize)!
        case .semibold:
            return UIFont(name: "Poppins-SemiBold", size: ofSize)!
        case .medium:
            return UIFont(name: "Poppins-Medium", size: ofSize)!
        default:
            return UIFont.PoppinsFont(ofSize: ofSize, weight: .regular)
        }
    }

}



