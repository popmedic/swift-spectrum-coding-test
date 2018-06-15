//
//  SpectrumCodingTestTests.swift
//  SpectrumCodingTestTests
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import XCTest
@testable import SpectrumCodingTest

class ValidatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSequenceValidator() {
        let validator = SequenceValidator(true)
        let givens = [
            ("abba", true),
            ("abab", false),
            ("abcab", true),
            ("dabcabcd", false),
            ("abcabdcadcabeabed", false),
            ("abcabdcadcebeabcd", true),
            ("1abc1ab. , ", true),
            ("3abc∆ab. , ,", false)
        ]
        for given in givens {
            XCTAssert(validator.isValid(string: given.0) == given.1,
                      "expected \(given.1) with \(given.0)")
        }
    }
}
