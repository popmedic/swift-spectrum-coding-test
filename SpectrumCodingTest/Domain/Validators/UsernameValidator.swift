//
//  UsernameValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 Validates the username making sure that it does not exist,
 and length > 1
 */
struct UsernameValidator: ValidatorProtocol {
    let userPersist:UserManagerProtocol
    /**
     initializes a new UsernameValidator with the given UserManager
 
     - parameters:
        - userManager: the user manager to use
 
     - returns:
     a new UsernameValidator that will check if a username exists
     using the given UserManager
     */
    init(userPersist:UserManagerProtocol) {
        self.userPersist = userPersist
    }
    /*
     validates that a username does not exist, and length > 1
     
     - parameters:
        - string: username to valid
     
     - returns:
     true if the string is **only** letters and numbers, false if it is not
     */
    func isValid(string: String) -> Bool {
        var exists = true
        userPersist.readUser(username: string) { (user, error) in
            if let error = error {
                print(error)
                exists = true
            } else {
                exists = user != nil
            }
        }
        return !exists
    }
}
