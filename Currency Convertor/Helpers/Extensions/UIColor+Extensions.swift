//
//  UIColor+Extensions.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

extension UIColor {
    
    static let mccPrimaryColor = hexStringToUIColor(hex: "#3FBFF3")
    static let mccSecondaryColor = hexStringToUIColor(hex: "#8D8EA1")
    
    // Color from hex string
    /// - Parameters:
    ///     - hex: String
    ///     - alpha: CGFloat default = 1.0
    /// - Returns: UIColor
    public class func hexStringToUIColor (hex:String, alpha: CGFloat = 1.0) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
    
        if ((cString.count) != 6) {
            return UIColor.gray
        }
    
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
    
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha)
    }
    
    class func colorWithGradient(frame: CGRect, colors: [UIColor]) -> UIColor {
        
        if frame.size.width <= 0 || frame.size.height <= 0 {
            return colors.first ?? .white
        }
        // create the background layer that will hold the gradient
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = frame
        
        // we create an array of CG colors from out UIColor array
        let cgColors = colors.map({$0.cgColor})
        
        backgroundGradientLayer.colors = cgColors
        
        UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
        backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIColor(patternImage: backgroundColorImage!)
    }
}
