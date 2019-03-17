//
//  LoginViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 11/28/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth


typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        makeAesthetic()
        
        super.viewDidAppear(animated)
    
    }
    
    func makeAesthetic() {
        
        password.isSecureTextEntry = true
        
        logInButton.layer.cornerRadius = 10
        logInButton.layer.masksToBounds = false
        logInButton.layer.shadowColor = UIColor.lightGray.cgColor
        logInButton.layer.shadowOpacity = 0.5
        logInButton.layer.shadowRadius = 10
        logInButton.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        
        
        email.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.email.text == "" || self.password.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                
                if let error = error {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                } else if Auth.auth().currentUser != nil {
                    
                    print("You have succesfully logged in")
                    
                    // go to home view controller after login is a success
                    let vc = UIStoryboard(type: .main).instantiateInitialViewController()
                    
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
}
    

