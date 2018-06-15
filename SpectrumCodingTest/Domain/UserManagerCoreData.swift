//
//  UserManagerCoreData.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit
import CoreData

/**
 Core Data implementation of a UserManager
 */
class UserManagerCoreData: UserManagerProtocol {
    private let container:NSPersistentContainer!
    
    init() {
        self.container = NSPersistentContainer(name: "SpectrumCodingTest")
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
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
    func createUser(username:String, password:String, image:Data?, completion:((NSError?)->Void)?) {
        let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: container.viewContext)!
        let user = NSManagedObject(entity: entity, insertInto: container.viewContext)
        
        user.setValue(username, forKeyPath: "username")
        user.setValue(password, forKeyPath: "password")
        if let image = image {
            user.setValue(image, forKeyPath: "image")
        } else {
            user.setValue(UIImagePNGRepresentation(UIImage(named:"DefaultUserImage")!)!, forKeyPath: "image")
        }
        
        do {
            try container.viewContext.save()
            completion?(nil)
        } catch let error as NSError {
            completion?(error)
        }
    }
    
    private func readUser(withPredicate:NSPredicate?, completion:((_ users:[User], _ error:NSError?)->Void)?) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserEntity")
        fetchRequest.predicate = withPredicate
        
        do {
            let users = try container.viewContext.fetch(fetchRequest)
            var res = [User]()
            for user in users {
                let id = user.objectID.uriRepresentation()
                let username = user.value(forKey: "username") as? String ?? ""
                let password = user.value(forKey: "password") as? String ?? ""
                let image = user.value(forKey: "image") as? Data
                    ?? UIImagePNGRepresentation(UIImage(named: "DefaultUserImage")!)!
                res.append((
                    id: id,
                    username: username,
                    password: password,
                    image: image
                ))
            }
            completion?(res, nil)
        } catch let error as NSError {
            completion?([], error)
        }
    }
    
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
    func readUser(id:Any, completion:((_ user:User?, _ error:NSError?)->Void)?) {
        if let id = id as? URL {
            if let managedObjectID = self.container.persistentStoreCoordinator.managedObjectID(
                forURIRepresentation: id) {
                let user = self.container.viewContext.object(with:managedObjectID)
                let res = User(
                    id: id,
                    username: user.value(forKey: "username") as? String ?? "",
                    password: user.value(forKey: "password") as? String ?? "",
                    image: user.value(forKey: "image") as? Data
                        ?? UIImagePNGRepresentation(UIImage(named: "DefaultUserImage")!)!
                )
                completion?(res, nil)
                return
            }
        }
        completion?(nil, nil)
    }
    
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
    func readUser(username:String, completion:((_ user:User?, _ error:NSError?)->Void)?) {
        self.readUser(withPredicate: NSPredicate(format: "%K == %@", "username", username)) { (users, error) in
            if let error = error {
                completion?(nil, error)
                return
            }
            if users.count == 0 {
                completion?(nil, nil)
                return
            }
            completion?(users[0], nil)
            
        }
    }
    
    /**
     gets all users
     
     - parameters:
         - username: the username of the user
         - completion: a block of code to run when the create user is finished. The block
         has an `users` and `error` passed in.  The `users` will contain an array Tuples of
         user information. If the error is nil then the create operation successed, otherwise
         check the error for more details.
     */
    func readAllUsers(completion:((_ users:[User], _ error:NSError?)->Void)?) {
        self.readUser(withPredicate: nil, completion: completion)
    }
    
    /**
     updates an user based on id
     
     - parameters:
         - id: the id of the user
         - completion: a block of code to run when the create user is finished. The block
         has an `error` passed in. If the error is nil then the create operation successed,
         otherwise check the error for more details.
     */
    func updateUser(id: Any, username:String?, password:String?, image:Data?, completion:((NSError?)->Void)?) {
        if let id = id as? URL {
            if let managedObjectID = self.container.persistentStoreCoordinator.managedObjectID(
                forURIRepresentation: id) {
                let user = self.container.viewContext.object(with:managedObjectID)
                if let username = username { user.setValue(username, forKey: "username") }
                if let password = password { user.setValue(password, forKey: "password") }
                if let image = image { user.setValue(image, forKey: "image") }
                if self.container.viewContext.hasChanges {
                    do {
                        try self.container.viewContext.save()
                    } catch {
                        completion?(error as NSError)
                        return
                    }
                }
            }
        }
        completion?(nil)
    }
    
    /**
     deletes an user based on id
     
     - parameters:
         - id: the id of the user to delete
         - username: the username to set with this user id, if nil don't change
         - password: the password to set with this user id, if nil don't change.
         - image: the image to set with this user id, if nil don't change.
         - completion: a block of code to run when the create user is finished. The block
         has an `error` passed in. If the error is nil then the create operation successed,
         otherwise check the error for more details.
     */
    func deleteUser(id: Any, completion:((NSError?)->Void)?) {
        if let id = id as? URL {
            if let managedObjectID = self.container.persistentStoreCoordinator.managedObjectID(
                forURIRepresentation: id) {
                let user = self.container.viewContext.object(with:managedObjectID)
                self.container.viewContext.delete(user)
                if self.container.viewContext.hasChanges {
                    do {
                        try self.container.viewContext.save()
                    } catch {
                        completion?(error as NSError)
                        return
                    }
                }
            }
        }
        completion?(nil)
    }
}
