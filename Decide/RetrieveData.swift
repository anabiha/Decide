//
//  RetrieveData.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/14/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RetrieveData {
    
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    

    
    func getNumberOfPosts() -> Int {
        
        return 0
        
    }
    
    func getTitle() -> String {
        
        var title = ""
        
        ref.child("posts").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            // get title
            title = value?["Title"] as? String ?? ""
            
        }) { (error) in
            
            print(error.localizedDescription)
            
        }
        
        return title
        
    }
    
    func getOptions() -> [String] {
        
        var options: [String] = []
        
        ref.child("posts").child(userID!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            // get title
            options = value?["Options"] as? [String] ?? [""]
            
        }) { (error) in
            
            print(error.localizedDescription)
            
        }
        
        return options
        
    }
    
    
}

