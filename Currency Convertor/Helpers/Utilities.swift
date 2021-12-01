//
//  Utilities.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

/// Class for common utilities
class Utilities: NSObject {
    
    /// To get attributted string
    /// - Parameter sourceString: main source string
    /// - Parameter targetString: target string which we want to format
    /// - Parameter font: font we want to apply
    /// - Parameter sourceColor: main source text color
    /// - Parameter targetColor: target string text color
    /// - Returns formatted mutable string
    static func getAttributtedString(sourceString: String, targetString: String, font: UIFont, sourceColor: UIColor, targetColor: UIColor) -> NSMutableAttributedString {

        let str = NSString(string: sourceString)
        let attributedTitle = NSMutableAttributedString(string: str as String,
                                                        attributes: [NSAttributedString.Key.foregroundColor : sourceColor,
                                                                     NSAttributedString.Key.font : font as Any])
        
        let targetRange = str.range(of: targetString)
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: targetColor, range: targetRange)
        
        return attributedTitle
    }

    /// To get currency symbol
    /// - Parameter code: currency code
    /// - Returns currency symbol or nil
    static func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    /// To show alert
    /// - Parameter title: alert title text
    /// - Parameter message: alert description / message text
    /// - Parameter viewController: parent view controller from where we want to show alert
    /// - Parameter completion: block which trigger when user dismiss/close the alert
    static func showAlertViewWithAction(_ title : String, _ message : String, _ viewController : UIViewController, completion:(() -> Void)?) {
        
        let alertView = UIAlertController(title: title as String, message: message as String, preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            if let completion = completion {
                completion()                
            }
        }
        alertView.addAction(cancelAction)
        viewController.present(alertView, animated: true, completion: nil)
    }
}
