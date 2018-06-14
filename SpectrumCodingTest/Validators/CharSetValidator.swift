//
//  CharSetValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 CharSetValidator validates that a string has characters in it,
 and that the charaters are a strict subset of a given character set
 */
struct CharSetValidator: ValidatorProtocol {
    private let charset:CharacterSet
    /**
     initializes the validator with the given character set
     
     - parameters:
        - charset: charaters to validate value is a strict subset of
     
     - returns:
     new CharSetValidator
     */
    init(charset: CharacterSet) {
        self.charset = charset
    }
    /**
     validates that string has characters in it,
     and that the charaters are a strict subset of a given character set
     
     - parameters:
        - string is the string to validate
     
     - returns:
     true if the string is valid, false if it is not valid.
     */
    func isValid(string: String) -> Bool {
        return string.count > 0 && CharacterSet(charactersIn: string).isStrictSubset(of: self.charset)
    }
}
