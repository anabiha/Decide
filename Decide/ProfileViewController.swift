//
//  ProfileViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        let storyboard = UIStoryboard(name: "Login", bundle:nil)
        
        if let initialViewController = storyboard.instantiateInitialViewController() {
            
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        }
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) { //a lifecycle method that is called before a view appears. I guess when animated is false, nothing appears.
        super.viewWillAppear(animated)
    }
    
    
}

