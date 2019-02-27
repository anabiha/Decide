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
        
        usernameTextField.layer.cornerRadius = 10
        
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = false
        nextButton.layer.shadowColor = UIColor.lightGray.cgColor
        nextButton.layer.shadowOpacity = 0.5
        nextButton.layer.shadowRadius = 10
        nextButton.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        
        super.viewDidLoad()
        
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {

        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        UserService.create(firUser, username: username) { (user) in
            
            guard let user = user else {
                
                //handle error
                
                return
                
            }
            
            User.setCurrent(user)
        
    
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
    
        
        }
    
    
    }
}
