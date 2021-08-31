//
//  Extensions.swift
//  Covid19 app
//
//  Created by David T on 6/1/21.
//

import UIKit

infix operator |: AdditionPrecedence
public extension UIColor {
    
    static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}


extension UIView {
    
    func layout(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    func xyAnchors(x: NSLayoutXAxisAnchor?, y: NSLayoutYAxisAnchor?, size: CGSize = .zero, xPadding: CGFloat = .zero, yPadding: CGFloat = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let x = x {
            centerXAnchor.constraint(equalTo: x, constant: xPadding).isActive = true
        }
        
        if let y = y {
            centerYAnchor.constraint(equalTo: y, constant: yPadding).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        layout(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }
}


extension UIColor {
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UserDefaults {
    
    func notificationIsEnabledForCountry(_ country: String) -> Bool {
        return bool(forKey: country)
    }
    
    func setNotificationIsEnabledForCountry(_ country: String, bool: Bool) {
        setValue(bool, forKey: country)
        synchronize()
    }
    
    func cacheIsAvailable() -> Bool {
        return bool(forKey: UserDefaultsCodingKeys.cacheIsAvailable.rawValue)
    }
    
    func setCacheIsAvailable(_ bool: Bool) {
        setValue(bool, forKey: UserDefaultsCodingKeys.cacheIsAvailable.rawValue)
        synchronize()
    }
    
    enum UserDefaultsCodingKeys: String, CodingKey {
        case cacheIsAvailable
    }
}

