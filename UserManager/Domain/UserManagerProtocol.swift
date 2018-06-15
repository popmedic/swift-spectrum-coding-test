//
//  UserManagerProtocol.swift
//  UserManager
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import Foundation

/**
 Tuple to use for a user
 */
typealias User = (id:Any, username:String, password:String, image:Data)

/**
 defines what is needed by the user manager domain, decoupling the infrastructure from the
 application.
 */
protocol UserManagerProtocol {
    /**
     creates a new user
     
     - parameters:
         - username: the user name to create
         - password: the password to store for the user
         - image: the image to store for the user (BLOB)
         - completion: a block of code to run when the create user is finished. The block
            has an `error` passed in.  If the `error` is `nil` then the create operation successed,
            otherwise check the `error` for more details.
     */
    func createUser(username:String, password:String, image:Data?, completion:((NSError?)->Void)?)
    /**
     gets a user with the given id
     
     - parameters:
         - id: the id of the user
         - completion: a block of code to run when the create user is finished. The block
         has an `user` and `error` passed in.  If the `user` is `nil`, then the given `id`
         does not exist, otherwise the `user` will contain a Tuple of user information.
         If the error is nil then the create operation successed, otherwise check the
         error for more details.
     */
    func readUser(id:Any, completion:((_ user:User?, _ error:NSError?)->Void)?)
    /**
     gets a user with the given username
     
     - parameters:
         - username: the username of the user
         - completion: a block of code to run when the create user is finished. The block
         has an `user` and `error` passed in.  If the `user` is `nil`, then the given `username`
         does not exist, otherwise the `user` will contain a Tuple of user information.
         If the error is nil then the create operation successed, otherwise check the
         error for more details.
     */
    func readUser(username:String, completion:((_ user:User?, _ error:NSError?)->Void)?)
    /**
     gets all users
     
     - parameters:
         - username: the username of the user
         - completion: a block of code to run when the create user is finished. The block
         has an `users` and `error` passed in.  The `users` will contain an array Tuples of
         user information. If the error is nil then the create operation successed, otherwise
         check the error for more details.
     */
    func readAllUsers(completion:((_ users:[User], _ error:NSError?)->Void)?)
    /**
     updates an user based on id
     
     - parameters:
         - id: the id of the user
         - completion: a block of code to run when the create user is finished. The block
         has an `error` passed in. If the error is nil then the create operation successed,
         otherwise check the error for more details.
     */
    func updateUser(id: Any, username:String?, password:String?, image:Data?, completion:((NSError?)->Void)?)
    /**
     deletes an user based on id
     
     - parameters:
         - id: the id of the user
         - username: the username to set with this user id, if nil don't change
         - password: the password to set with this user id, if nil don't change.
         - image: the image to set with this user id, if nil don't change.
         - completion: a block of code to run when the create user is finished. The block
         has an `error` passed in. If the error is nil then the create operation successed,
         otherwise check the error for more details.
     */
    func deleteUser(id: Any, completion:((NSError?)->Void)?)
}
