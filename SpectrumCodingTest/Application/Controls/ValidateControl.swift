//
//  ValidateControl.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/13/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

@IBDesignable
class ValidateControl: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBInspectable var checkedString:String! = "✅" {
        didSet {
            if isValid {
                self.checkedLabel.text = self.checkedString
            }
        }
    }
    @IBInspectable var exedString:String! = "❌" {
        didSet {
            if !self.isValid {
                self.checkedLabel.text = self.exedString
            }
        }
    }
    @IBInspectable var descriptionText: String! = "blah blab blab" {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }
    @IBInspectable var isValid:Bool = true {
        didSet {
            self.checkedLabel.text = self.isValid ? self.checkedString : self.exedString
        }
    }
    
    var validators:[ValidatorProtocol] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initNib()
    }
    
    private func initNib() {
        let bundle = Bundle(for: ValidateControl.self)
        bundle.loadNibNamed("ValidateControl", owner: self, options: nil)
        self.addSubview(containerView)
        self.containerView.frame = self.bounds
        self.containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.checkedLabel.text = checkedString
        self.descriptionLabel.text = exedString
    }
    
    func validate(string:String) {
        var valid = true
        for validator in self.validators {
            valid = valid && validator.isValid(string: string)
        }
        self.isValid = valid
    }
}
