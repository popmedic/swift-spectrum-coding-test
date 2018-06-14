//
//  UserManagerCoreData.swift
//  SpectrumCodingTest
//
//  Created by Kevin Scardina on 6/12/18.
//  Copyright © 2018 Kevin Scardina. All rights reserved.
//

import UIKit
import CoreData

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
    
    func createUser(username:String, password:String, image:Data?, completion:((NSError?)->Void)?) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: container.viewContext)!
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
    
    func readUser(withPredicate:NSPredicate?, completion:((_ users:[SCTUser], _ error:NSError?)->Void)?) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.predicate = withPredicate
        
        do {
            let users = try container.viewContext.fetch(fetchRequest)
            var res = [SCTUser]()
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
    
    func readUser(id:Any, completion:((_ user:SCTUser?, _ error:NSError?)->Void)?) {
        if let id = id as? URL {
            if let managedObjectID = self.container.persistentStoreCoordinator.managedObjectID(
                forURIRepresentation: id) {
                let user = self.container.viewContext.object(with:managedObjectID)
                let res = SCTUser(
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
    
    func readUser(username:String, completion:((_ user:SCTUser?, _ error:NSError?)->Void)?) {
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
    
    func readAllUsers(completion:((_ users:[SCTUser], _ error:NSError?)->Void)?) {
        self.readUser(withPredicate: nil, completion: completion)
    }
    
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
