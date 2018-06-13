//
//  LengthValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

struct LengthValidator: ValidatorProtocol {
    private let range:Range<Int>
    init(range:Range<Int>) {
        self.range = range
    }
    
    func isValid(string: String) -> Bool {
        return range.contains(string.count)
    }
}
