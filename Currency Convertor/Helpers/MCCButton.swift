//
//  MCCButton.swift
//  Currency Convertor
//
//  Created by Ankur Kathiriya on 02/11/21.
//

import UIKit

class MCCButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Set attributes of button
    private func setup() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.height / 2
        self.titleLabel?.font = MCCCarosFont.Regular.withSize(20)
        self.backgroundColor = UIColor.mccPrimaryColor
        self.setTitleColor(.white, for: .normal)
    }

}
