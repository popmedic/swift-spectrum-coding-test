//
//  CharSetValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

struct CharSetValidator: ValidatorProtocol {
    private let charset:CharacterSet
    init(charset: CharacterSet) {
        self.charset = charset
    }
    
    func isValid(string: String) -> Bool {
        return string.count > 0 && CharacterSet(charactersIn: string).isStrictSubset(of: self.charset)
    }
}
