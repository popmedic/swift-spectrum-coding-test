//
//  PasswordValidationView.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/13/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit

@IBDesignable
class PasswordValidationView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lettersAndDigitsValidateView: ValidateView!
    @IBOutlet weak var between5And12ValidateView: ValidateView!
    @IBOutlet weak var sameSequenceValidateView: ValidateView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initNib()
    }
    
    private func initNib() {
        let bundle = Bundle(for: ValidateView.self)
        bundle.loadNibNamed("PasswordValidationView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.between5And12ValidateView.validators.append(LengthValidator.init(range: 5..<13))
        self.lettersAndDigitsValidateView.validators.append(CharSetValidator(charset: CharacterSet.alphanumerics))
        self.lettersAndDigitsValidateView.validators.append(LetterAndNumberValidator())
    }
    
    func validate(string:String) -> Bool {
        self.lettersAndDigitsValidateView.validate(string: string)
        self.between5And12ValidateView.validate(string: string)
        return self.lettersAndDigitsValidateView.isValid &&
            self.between5And12ValidateView.isValid &&
            self.sameSequenceValidateView.isValid
    }
}
