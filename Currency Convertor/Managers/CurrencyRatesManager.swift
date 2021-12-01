//
//  CurrencyRatesManager.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

class CurrencyRatesManager {

    /// To get shared object
    static let shared = CurrencyRatesManager()
    
    /// To get currency rates based on base currency
    ///  - Parameter base: base currency name
    ///  - Parameter successBlock: currencyRates class object which is parsed from API response
    ///  - Parameter errorBlock: error message if anything goes wrong from API or while parsing the response which is not expected from API
    func getCurrencyRates(base: String,
                          successBlock :@escaping (_ currencyRates : CurrencyRates) -> (),
                          errorBlock :@escaping (_ error : String) -> ()) {
        let url = Apis.GET_LATEST_RATES + "?access_key=" + Constants.accessKey + "&base=" + base
        
        ServiceManager.shared.processServiceCall(serviceName: url, parameters: nil, showLoader: false, requestType: "POST") { response in
            
            var rates : CurrencyRates!
            if let _ = response["success"] as? Bool {
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: response, options: [])
                    
                    let jsonDecoder = JSONDecoder()
                    
                    rates = try jsonDecoder.decode(CurrencyRates.self, from: data)
                    
                    successBlock(rates)
                }
                catch {
                    print("error in json \(error)")
                    errorBlock("Something went wrong! Error in parsing API response.")
                }
            } else {
                errorBlock("Something went wrong! Error from API.")
            }
            
        } errorBlock: { error in
            errorBlock("Something went wrong!")
        }
    }
}
