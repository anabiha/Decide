//
//  CreateUsernameViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 11/29/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {

        //guard to check that a FIRUser is logged in and that the user has provided a username in the text field
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            
            guard let user = user else {
                
                //handle error
                
                return
                
            }
            
            User.setCurrent(user)
        
        
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
            if let initialViewController = storyboard.instantiateInitialViewController() {
            
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            
        }
    
        
        }
    
    
    }
}
