//
//  UsernameValidator.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

struct UsernameValidator: ValidatorProtocol {
    let userPersist:UserManagerProtocol
    init(userPersist:UserManagerProtocol) {
        self.userPersist = userPersist
    }
    
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
