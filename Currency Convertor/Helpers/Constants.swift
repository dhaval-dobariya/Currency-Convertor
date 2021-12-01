//
//  Constants.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

/// Class for constants
class Constants {
    static let accessKey = "82ab5235ebced53e3022692ccd9f0121"
}

/// Enum of API URLs
enum Apis {
    
    /// Base URL
    static let BASE_API_URL  = "http://data.fixer.io/api/"

    /// API to get latest currency rates
    static let GET_LATEST_RATES = BASE_API_URL + "latest"
}

