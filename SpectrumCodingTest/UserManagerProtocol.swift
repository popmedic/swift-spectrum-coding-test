//
//  UserManagerProtocol.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 Tuple to use for a user
 */
typealias SCTUser = (id:Any, username:String, password:String, image:Data)

protocol UserManagerProtocol {
    func createUser(username:String, password:String, image:Data?, completion:((NSError?)->Void)?)
    func readUser(id:Any, completion:((_ user:SCTUser?, _ error:NSError?)->Void)?)
    func readUser(username:String, completion:((_ user:SCTUser?, _ error:NSError?)->Void)?)
    func readAllUsers(completion:((_ users:[SCTUser], _ error:NSError?)->Void)?)
    func updateUser(id: Any, username:String?, password:String?, image:Data?, completion:((NSError?)->Void)?)
    func deleteUser(id: Any, completion:((NSError?)->Void)?)
}
