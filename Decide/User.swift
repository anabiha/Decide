//
//  User.swift
//  Decide
//
//  Created by Ayesha Nabiha on 11/29/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: Codable {
    
    let uid: String
    let username: String
    
    // creates a private static variable to hold the current user
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
    
   
    static var current: User {
        
        guard let currentUser = _current else {
            
            fatalError("Error: current user doesnt exist")
            
        }
        
        return currentUser
        
    }
    

    static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            
            if let data = try? JSONEncoder().encode(user) {
                
               UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
                
            }
        }
        
        _current = user
        
    }
    
    
}
