//
//  ResetPasswordViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    
    @IBAction func resetPassword(_ sender: Any) {
        
        if self.email.text == "" {
            
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
            
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    
                    title = "Error!"
                    message = (error?.localizedDescription)!
                    
                } else {
                    
                    title = "Success!"
                    message = "Password reset email sent."
                    
                    self.email.text = ""
                    
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            })
            
            
        }
        
        
    }
    
    @IBAction func goBackToLogin(_ sender: Any) {
        
        let vc = UIStoryboard(type: .login).instantiateInitialViewController()
        
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func goBackToSignUp(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signup")
        
        self.present(vc!, animated: true, completion: nil)
        
    }
    

}
