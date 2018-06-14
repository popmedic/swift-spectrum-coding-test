//
//  LengthValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 validates that the length of a string is between the given range
*/
struct LengthValidator: ValidatorProtocol {
    private let range:Range<Int>
    /**
     initialize the LengthValidator with the given range
     
     - parameters:
        - range: integers to make sure string count is between
     
     - returns:
     new LengthValidator
     */
    init(range:Range<Int>) {
        self.range = range
    }
    /**
     validates that the length of a string is between the given range
     
     - parameters:
        - string: the string to validate
     
     - returns:
     true if the string is valid, false if it is not valid.
     */
    func isValid(string: String) -> Bool {
        return range.contains(string.count)
    }
}
