//
//  Post.swift
//  Decide
//
//  Created by Ayesha Nabiha on 4/11/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//


import UIKit
import Firebase

class Post {
    
    var title: String
    var options: [String]
    
    init() {
        
        self.title = ""
        self.options = []
        
    }
    
    init(title: String, options: [String]) {
        
        self.title = title
        self.options = options
        
    }
    
    
}
