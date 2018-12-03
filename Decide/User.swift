//
//  User.swift
//  Decide
//
//  Created by Ayesha Nabiha on 11/29/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    
    let uid: String
    let username: String
    
    //create a private static variable to hold our current user
    private static var _current: User?
    
    init(uid: String, username: String) {
        
        self.uid = uid
        self.username = username
        
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        
    }
    
    //create a computed variable that only has a getter than can access the private _current variable
    static var current: User {
        
        //check that _current that is of type User? isn't nil. If _current is nill and current is being read, the guard statement will crash with fatalError()
        guard let currentUser = _current else {
            
            fatalError("Error: current user doesnt exist")
            
        }
        
        //if _current isn't nil, it will be returned to the user
        return currentUser
        
    }
    
    //create a custom setter method to set the current user
    static func setCurrent(_ user: User) {
        
        _current = user
        
    }
    
    
}
