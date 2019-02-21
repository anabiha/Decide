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
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        
       super.viewDidLoad()
        
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        if let storyboard = self.storyboard {
            
            let vc = storyboard.instantiateViewController(withIdentifier: "Login")
            
            self.present(vc, animated: true, completion: nil)
            
            
        }
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) { //a lifecycle method that is called before a view appears. I guess when animated is false, nothing appears.
        super.viewWillAppear(animated)
    }
    
    
}

