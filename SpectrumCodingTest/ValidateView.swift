//
//  ValidateView.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/13/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

@IBDesignable
class ValidateView: UIView {
    @IBInspectable var checkedString:String! = "✅"
    @IBInspectable var exedString:String! = "❌"
    @IBInspectable var textField:UITextField?
    var validator:ValidatorProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    func initNib() {
        let bundle = Bundle(for: ValidateView.self)
        bundle.loadNibNamed("ValidateView", owner: self, options: nil)
    }
}
