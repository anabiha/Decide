//
//  SignUpViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/12/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        passwordTextField.isSecureTextEntry = true
        
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        // if the user leaves the email field, text field, or both blank, have a popup
        if emailTextField.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            // writing user to the database
            let ref = Database.database().reference().root
            
            // creates a user account in firebase
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                // check to see if there is any sign up error
                if error == nil {
                    
                    print("You have successfully signed up")
                ref.child("users").child((user?.user.uid)!).setValue(self.emailTextField.text)
                    
                    // goes to the setup page which lets the user take a photo for their profile picture and create a username
                    let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "createUser") as UIViewController
                    
                    self.present(viewController, animated: false, completion: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
            }
            
        }
        
    }
    
    
    @IBAction func goBackToLogin(_ sender: Any) {
        
        let vc = UIStoryboard(type: .login).instantiateInitialViewController()
        
        self.present(vc!, animated: true, completion: nil)
        
    
    }
    
}
