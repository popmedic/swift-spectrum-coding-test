//
//  UserManagerTests.swift
//  UserManagerTests
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import XCTest
@testable import UserManager

class ValidatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLetterAndNumberValidator() {
        let validator = LetterAndNumberValidator()
        let givens = [
            ("abba1", true),
            ("abcab23", true),
            ("dabcabcd", false),
            ("abcabdcadcabeabed", false),
            ("abcabdcadcebe11", true),
            ("1abc1ab", true)
        ]
        for given in givens {
            XCTAssert(validator.isValid(string: given.0) == given.1,
                      "expected \(given.1) with \(given.0)")
        }
    }
    
    func testUsernameValidator() {
        let userManager = UserManagerCoreData()
        userManager.createUser(username: "kevin", password: "kevin1", image: nil) { (error) in
            XCTAssert(error == nil, "\(error!)")
        }
        let validator = UsernameValidator(userManager: userManager)
        let givens = [
            ("kevin", false),
            ("kevin1", true)
        ]
        for given in givens {
            XCTAssert(validator.isValid(string: given.0) == given.1,
                      "expected \(given.1) with \(given.0)")
        }
        userManager.readUser(username: "kevin") { (user, error) in
            XCTAssert(error == nil, "\(error!)")
            XCTAssert(user != nil, "username kevin should exist")
            userManager.deleteUser(id: user!.id, completion: { (error) in
                XCTAssert(error == nil, "\(error!)")
            })
        }
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
