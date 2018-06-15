//
//  ValidatorProtocol.swift
//  UserManager
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 Protocol for all validators to fulfill
 */
protocol ValidatorProtocol {
    /**
     isValid performs a check on string
     
     - parameters:
        - string: String to validate
     
     - returns:
     true if string passes validation, false if it does not
     */
    func isValid(string:String) -> Bool
}
