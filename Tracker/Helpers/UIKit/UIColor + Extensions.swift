//
//  UIColor + Extensions.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 27.06.2023.
//

import UIKit

extension UIColor {
    
    static let uiBackground = UIColor(named: "UIBackground") ?? clear
    static let uiBlack = UIColor(named: "UIBlack") ?? clear
    static let uiBlue = UIColor(named: "UIBlue") ?? clear
    static let uiGray = UIColor(named: "UIGray") ?? clear
    static let uiLightGray = UIColor(named: "UILightGray") ?? clear
    static let uiRed = UIColor(named: "UIRed") ?? clear
    static let uiWhite = UIColor(named: "UIWhite") ?? clear
    
    static let toggleBlackWhiteColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    static let blackWhiteColorCell = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    static let tabBarBorderLineColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.uiGray
        } else {
            return UIColor.black
        }
    }
    
    static let blackWhiteColorButton = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.uiWhite
        } else {
            return UIColor.black
        }
    }
    
    static let blackGrayColorButton = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    static func hexString(from color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }

    static func color(from hex: String) -> UIColor {
        var hexColor: String
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        } else {
            hexColor = hex
        }
        var rgbValue:UInt64 = 0
        Scanner(string: hexColor).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
