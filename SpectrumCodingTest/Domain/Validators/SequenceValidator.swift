//
//  SequenceValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/14/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 Validates that a given string does not have contiguous substrings
 of the same sequence.
 
 # Implementation:
    1. create a history, a dictionary with keys of the characters, and
        values of an array of indices into the string being validated
    2. if the current indexed character is empty in history, then create a
        new array indices and add the current index
    3. if the current index does exist, see if any of the last substrings
        is the same as the substring current index to distance of last
        substring. If they are the same, then it has contiguous substrings
        of the same sequence, return false. If it gets thru the entire
        string without returning, then return true.
 */
struct SequenceValidator: ValidatorProtocol {
    var allowDuplicateLetter:Bool
    /**
     initializes a new SequenceValidator
     - parameters:
        - allowDuplicateLetter:
        If true isValid is **not** return false if a single character is duplicated,
        like aa in naan
     - returns:
     new SequenceValidator
     */
    init(_ allowDuplicateLetter:Bool = false) {
        self.allowDuplicateLetter = allowDuplicateLetter
    }
    
    /**
     Validates that a given string does not have contiguous substrings
     of the same sequence.
 
     - parameters:
        - string: string to validate
     - returns:
     true if the string does **not** have contiguous substrings of the same sequence,
     otherwise return false
     */
    func isValid(string: String) -> Bool {
        var history = [Character:[String.Index]]()
        for here in string.indices[string.startIndex..<string.endIndex] {
            // see if we have this char already in the history of indices
            let char = string[here]
            if let indices = history[char] {
                // see if the previous time (there) we saw this char is
                // the same as from here to (here - there).
                for there in indices {
                    let previousString = string[there..<here]
                    // check to make sure that if we are allowing duplicate letters (ie oo like in moon)
                    // if so ignore strings of 1 letter
                    if previousString.count > 1 || !allowDuplicateLetter {
                        let distance = string.distance(from: there, to: here)
                        if let endIndex = string.index(here, offsetBy: distance, limitedBy: string.endIndex) {
                            let currentString = string[here..<endIndex]
                            // if the current string is the same as the previous string,
                            // we have contiguous character sequences
                            if currentString == previousString {
                                return false
                            }
                        }
                    }
                }
                // append this index to the history
                history[string[here]]!.append(here)
            } else {
                // first time seen, create this letters history
                history[string[here]] = Array<String.Index>(arrayLiteral: here)
            }
        }
        return true
    }
}
