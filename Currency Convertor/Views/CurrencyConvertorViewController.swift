//
//  CurrencyConvertorViewController.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

class CurrencyConvertorViewController: UIViewController {

    //MARK: Variables
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var firstCurrencySymbolInTopHeader: UIImageView!
    @IBOutlet weak var secondCurrencySymbolInTopHeader: UIImageView!

    @IBOutlet weak var firstCurrencySymbol: UIImageView!
    @IBOutlet weak var firstCurrencyTextField: UITextField!

    @IBOutlet weak var secondCurrencySymbol: UIImageView!
    @IBOutlet weak var secondCurrencyTextField: UITextField!

    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    @IBOutlet weak var availableBalanceLabel: UILabel!
    @IBOutlet weak var availableBalanceStaticText: UILabel!
    
    @IBOutlet weak var feesLabel: UILabel!
    @IBOutlet weak var feesStaticText: UILabel!
    
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var from: String = "EUR"
    var to: String = "USD"
    var rates: [String: Double]!
    var currencies = [String]()
    var isSelectingForFromCurrency: Bool = true
    
    //MARK: View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        
        getData(completionBlock: {
            
        })
    }
    
    //MARK: API call
    /// To get data
    private func getData(completionBlock :@escaping () -> ()) {
        CurrencyRatesManager.shared.getCurrencyRates(base: from, successBlock: { currencyRates in
            self.rates = currencyRates.rates
            self.currencies = currencyRates.rates.map { $0.key }
            self.setExchangeRateText()
            completionBlock()
        }, errorBlock: { error in
            Utilities.showAlertViewWithAction(error, "", self, completion: nil)
        })
    }
    
    //MARK: Helper methods
    private func setup() {
        firstCurrencyTextField.text = "1"
        secondCurrencyTextField.text = ""
        
        firstCurrencyTextField.font = MCCDMSansFont.Regular.withSize(40)
        secondCurrencyTextField.font = MCCDMSansFont.Regular.withSize(40)
    }
    
    /// Set exchange rate text
    private func setExchangeRateText() {
        recalculateAmounts()
        calculateFees()
        
        guard let toRateDict = self.rates.filter ({ $0.key == to }).first else {
            return
        }
        
        guard let fromSymbol = Utilities.getSymbol(forCurrencyCode: from),
                let toSymbol = Utilities.getSymbol(forCurrencyCode: to) else {
            return
        }
        
        let toRateString: String = String(format: "%@%f", arguments: [toSymbol, toRateDict.value])
        
        let message = String(format: "Exchange rate %@1 = %@", arguments: [fromSymbol, toRateString])
        exchangeRateLabel.attributedText = Utilities.getAttributtedString(sourceString: message, targetString: toRateString, font: MCCDMSansFont.Regular.withSize(17), sourceColor: .mccSecondaryColor, targetColor: .mccPrimaryColor)
    }
    
    /// Calculate fees
    private func calculateFees() {
        if let fromSymbol = Utilities.getSymbol(forCurrencyCode: from) {
            
            if let fromCurrencyAmount = firstCurrencyTextField.text,
                let convertedFromCurrencyAmount = Double(fromCurrencyAmount) {
                
                feesLabel.text = String(format: "%@%.5f", arguments: [fromSymbol, ((convertedFromCurrencyAmount * 0.5) / 100)])
            }
        }
    }
    
    /// Change TO currency symbol
    private func changeToCurrencySymbol() {
        guard let toSymbol = Utilities.getSymbol(forCurrencyCode: to),
                let toImage = toSymbol.toImage() else {
            return
        }
        
        for currencySymbol in [secondCurrencySymbol, secondCurrencySymbolInTopHeader] {
            currencySymbol?.image = toImage
        }
    }
    
    /// Change FROM currency symbol
    private func changeFromCurrencySymbol() {
        guard let fromSymbol = Utilities.getSymbol(forCurrencyCode: from),
              let fromImage = fromSymbol.toImage() else {
            return
        }
        
        for currencySymbol in [firstCurrencySymbol, firstCurrencySymbolInTopHeader] {
            currencySymbol?.image = fromImage
        }
    }
    
    /// Recalculate amounts after user change base or target currency
    private func recalculateAmounts() {
        guard let fromRateDict = self.rates.filter ({ $0.key == from }).first else {
            return
        }
        
        guard let toRateDict = self.rates.filter ({ $0.key == to }).first else {
            return
        }
        
        if let toCurrencyAmount = secondCurrencyTextField.text, let convertedToCurrencyAmount = Double(toCurrencyAmount) {
            let calculatedToAmount = convertedToCurrencyAmount * toRateDict.value
            secondCurrencyTextField.text = String(format: "%.6f", arguments: [(calculatedToAmount)])
        }
        
        if let fromCurrencyAmount = firstCurrencyTextField.text, let convertedFromCurrencyAmount = Double(fromCurrencyAmount) {
            let calculatedFromAmount = convertedFromCurrencyAmount / fromRateDict.value
            firstCurrencyTextField.text = String(format: "%.6f", arguments: [(calculatedFromAmount)])
        }
        
    }
    
    //MARK: IBActions
    @IBAction func fromCurrencyTapped(_ sender: UIControl) {
        Utilities.showAlertViewWithAction("Need API", "We need API which supports base other than EUR, free version only supports base = EUR", self, completion: nil)
        
        //FIXME: Need API support which can accept base parameter
        /*
        isSelectingForFromCurrency = true
        pickerContainerView.isHidden = false
        pickerView.reloadAllComponents()
        */
    }
    
    @IBAction func toCurrencyTapped(_ sender: UIControl) {
        isSelectingForFromCurrency = false
        pickerContainerView.isHidden = false
        pickerView.reloadAllComponents()
    }
    
    @IBAction func invertCurrencyTapped(_ sender: UIControl) {
        guard let fromRateDict = self.rates.filter ({ $0.key == from }).first else {
            return
        }
        
        guard let toRateDict = self.rates.filter ({ $0.key == to }).first else {
            return
        }
        
        self.rates[from] = fromRateDict.value / toRateDict.value
        self.rates[to] = 1
        
        let temp = from
        from = to
        to = temp
        
        changeFromCurrencySymbol()
        changeToCurrencySymbol()
        
        let tempAmt = firstCurrencyTextField.text
        firstCurrencyTextField.text = secondCurrencyTextField.text
        secondCurrencyTextField.text = tempAmt

        //FIXME: Need to implement API with base = user's selected curremcy, so that we have rate based on base currency, right now we have for EUR only
        /*
        getData(completionBlock: {
            self.recalculateAmounts()
        })
        */
    }
    
    @IBAction func continueTapped(_ sender: MCCButton) {
        
    }
    
    @IBAction func doneTappedAtCurrencyPicker(_ sender: UIBarButtonItem) {
        pickerContainerView.isHidden = true
        
        calculateFees()
        setExchangeRateText()

        if isSelectingForFromCurrency {
            changeFromCurrencySymbol()
        } else  {
            changeToCurrencySymbol()
        }
    }
    
}

//MARK: UIPickerViewDataSource
extension CurrencyConvertorViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }

}

//MARK: UIPickerViewDelegate
extension CurrencyConvertorViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isSelectingForFromCurrency {
            from = currencies[row]
        } else {
            to = currencies[row]
        }
    }
}

//MARK: UITextFieldDelegate
extension CurrencyConvertorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var updatedText = ""
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            updatedText = text.replacingCharacters(in: textRange, with: string)
            
            guard let currentTypedAmount = Double(updatedText) else {
                return true
            }
            
            if textField == firstCurrencyTextField {
                
                guard let toRateDict = self.rates.filter ({ $0.key == to }).first else {
                    return true
                }
                
                let calculatedToAmount = currentTypedAmount * toRateDict.value
                secondCurrencyTextField.text = String(format: "%.6f", arguments: [(calculatedToAmount)])
                
            } else if textField == secondCurrencyTextField {
                guard let fromRateDict = self.rates.filter ({ $0.key == from }).first else {
                    return true
                }
                
                let calculatedFromAmount = currentTypedAmount / fromRateDict.value
                firstCurrencyTextField.text = String(format: "%.6f", arguments: [(calculatedFromAmount)])
            }
            
            calculateFees()
        }
        
        return true
    }
}
