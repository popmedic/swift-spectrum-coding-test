//
//  UserManagerCoreDataTests.swift
//  SpectrumCodingTestTests
//
//  Created by Kevin Scardina on 6/14/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import XCTest
@testable import SpectrumCodingTest

class UserManagerCoreDataTests: XCTestCase {
    func test() {
        let userManager = UserManagerCoreData()
        userManager.createUser(username: "kevin", password: "kevin1", image: nil) { (error) in
            XCTAssert(error == nil, "\(error!)")
            userManager.readUser(username: "kevin", completion: { (user, error) in
                XCTAssert(error == nil, "\(error!)")
                XCTAssert(user != nil, "username kevin should exist")
                userManager.updateUser(
                    id: user!.id,
                    username: "kevin1",
                    password: "kevin2",
                    image: nil,
                    completion: { (error) in
                    XCTAssert(error == nil, "\(error!)")
                })
                userManager.readUser(id: user!.id, completion: { (user, error) in
                    XCTAssert(error == nil, "\(error!)")
                    XCTAssert(user != nil, "user with id should exist")
                    XCTAssert(user!.username == "kevin1" && user!.password == "kevin2", "failed to update")
                    userManager.deleteUser(id: user!.id, completion: { (error) in
                        XCTAssert(error == nil, "\(error!)")
                    })
                })
            })
        }
    }
}
