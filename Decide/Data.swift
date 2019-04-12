//
//  Data.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/27/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import Firebase

class Data {
    
    var titles: [String]
    var arrOptions: [[String]]
    var numberOfPosts: Int
    var posts: [String : Any]
    
    init() {

        self.numberOfPosts = 0
        self.posts = [:]
        self.titles = []
        self.arrOptions = [[]]
    
    }
    
    init(posts: [String : Any]) {
        
        self.titles = posts["title"] as! [String]
        self.arrOptions = posts["options"] as! [[String]]
        self.numberOfPosts = posts.count
        self.posts = posts
    
    }
    
    init(titles: [String], arrOptions: [[String]], numberOfPosts: Int, posts: [String:Any]) {
        
        self.numberOfPosts = numberOfPosts
        self.posts = posts
        self.titles = titles
        self.arrOptions = arrOptions
        
    }
    
    func observeUserPosts(completion: @escaping ([String:Any]) -> Void){
        
        let userKey = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("user-posts").child(userKey!)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : Any] ?? [:]
            
            completion(posts)
            
        })
        
    }

    
}
