//
//  MCCFont.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

enum MCCCarosFont: String {
    
    // Light
    case Light = "CarosSoftLight"
    
    // Regular
    case Regular = "CarosSoft"
    
    // Bold
    case Bold = "CarosSoftBold"
    
    // Black
    case Black = "CarosSoftBlack"
    
    func withSize(_ size: CGFloat) -> UIFont {
        
        guard let customFont = UIFont(name: self.rawValue, size: size) else {
            fatalError("""
                Failed to load the "\(self.rawValue)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return customFont
    }
}

enum MCCDMSansFont: String {
    
    // Regular
    case Regular = "DMSans-Regular"

    // Medium
    case Medium = "DMSans-Medium"
    
    // Bold
    case Bold = "DMSans-Bold"
    
    func withSize(_ size: CGFloat) -> UIFont {
        
        guard let customFont = UIFont(name: self.rawValue, size: size) else {
            fatalError("""
                Failed to load the "\(self.rawValue)" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        return customFont
    }
}

