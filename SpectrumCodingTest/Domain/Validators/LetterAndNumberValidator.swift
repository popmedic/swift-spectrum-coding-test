//
//  LetterAndNumberValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 validates that a string containes **only** letters and numbers
 */
struct LetterAndNumberValidator: ValidatorProtocol {
    /**
     validates that a string containes **only** letters and numbers
 
     - parameters:
        - string: string to valid
     
     - returns:
     true if the string is **only** letters and numbers, false if it is not
     */
    func isValid(string: String) -> Bool {
        let charSet = CharacterSet(charactersIn: string)
        var numbers = CharacterSet.decimalDigits
        numbers.remove(".")
        var letters = CharacterSet.letters
        letters.remove(".")
        return !charSet.isDisjoint(with: numbers) &&
               !charSet.isDisjoint(with: letters)
    }
}
