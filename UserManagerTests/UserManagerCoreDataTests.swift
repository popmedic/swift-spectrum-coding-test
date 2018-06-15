//
//  UserManagerCoreDataTests.swift
//  UserManagerTests
//
//  Created by Kevin Scardina on 6/14/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import XCTest
@testable import UserManager

class UserManagerCoreDataTests: XCTestCase {
    func test() {
        let userManager = UserManagerCoreData()
        userManager.createUser(username: "stan", password: "stan1", image: nil) { (error) in
            XCTAssert(error == nil, "\(error!)")
            userManager.readUser(username: "stan", completion: { (user, error) in
                XCTAssert(error == nil, "\(error!)")
                XCTAssert(user != nil, "username stan should exist")
                userManager.updateUser(
                    id: user!.id,
                    username: "stan1",
                    password: "stan2",
                    image: nil,
                    completion: { (error) in
                    XCTAssert(error == nil, "\(error!)")
                })
                userManager.readUser(id: user!.id, completion: { (user, error) in
                    XCTAssert(error == nil, "\(error!)")
                    XCTAssert(user != nil, "user with id should exist")
                    XCTAssert(user!.username == "stan1" && user!.password == "stan2", "failed to update")
                    userManager.deleteUser(id: user!.id, completion: { (error) in
                        XCTAssert(error == nil, "\(error!)")
                    })
                })
            })
        }
    }
}
