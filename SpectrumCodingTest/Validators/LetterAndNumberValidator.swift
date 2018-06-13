//
//  LetterAndNumberValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

struct LetterAndNumberValidator: ValidatorProtocol {
    func isValid(string: String) -> Bool {
        let charSet = CharacterSet(charactersIn: string)
        return !charSet.isDisjoint(with: CharacterSet.decimalDigits) &&
               !charSet.isDisjoint(with: CharacterSet.letters)
    }
}
