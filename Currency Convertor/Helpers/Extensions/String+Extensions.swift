//
//  String+Extensions.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

/// String extensions
extension String {
    /// To get image from text
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
    /// To get image from string
    ///  - Parameter handler: contains UIImage or nil
    func stringToImage(_ handler: @escaping ((UIImage?)->())) {
        if let url = URL(string: self) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    handler(image)
                }
            }.resume()
        }
    }
}
