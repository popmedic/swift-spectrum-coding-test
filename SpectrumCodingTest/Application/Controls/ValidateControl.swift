//
//  ValidateControl.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/13/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

/**
 An IBDesignable control for showing the validation.
 The view/UI for this control is a emoji on the left,
 with a description on the right.  It will change the
 emoji to represent if a given string is valid or not
 based on the ValidatorProtocol(s) assigned to the
 control
 */
@IBDesignable
class ValidateControl: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    /**
     emoji/string shown if the validator(s) pass
     */
    @IBInspectable var successString:String! = "✅" {
        didSet {
            if isValid {
                self.checkedLabel.text = self.successString
            }
        }
    }
    /**
     emoji/string shown if the validator(s) fail
     */
    @IBInspectable var failString:String! = "❌" {
        didSet {
            if !self.isValid {
                self.checkedLabel.text = self.failString
            }
        }
    }
    /**
     description text to show on the right
     */
    @IBInspectable var descriptionText: String! = "blah blab blab" {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }
    /**
     when set changes the display to the checkedLabel/exedLabel
     */
    @IBInspectable var isValid:Bool = true {
        didSet {
            self.checkedLabel.text = self.isValid ? self.successString : self.failString
        }
    }
    /**
     a collection of validators `AND` together to validate a string
     */
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
        self.checkedLabel.text = successString
        self.descriptionLabel.text = failString
    }
    /**
     will use the controls validators to valid the given string, updating
     the view based on the result
     
     - parameters:
        - string: string to validate agaist validators
     */
    func validate(string:String) {
        var valid = true
        for validator in self.validators {
            valid = valid && validator.isValid(string: string)
        }
        self.isValid = valid
    }
}
