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
  
    
    override func viewDidLoad() {
        
        logInButton.layer.cornerRadius = 10
        
        
        
        super.viewDidLoad()
    
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
        
    }
    
    
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if let error = error {
            
            assertionFailure("Error signing in: \(error.localizedDescription)")
            
            return
            
        }
        
        // check that the FIRUSer returned from authentication is not nil by unwrapping it
        guard let user = authDataResult?.user
            else{ return }
        
    
        UserService.show(forUID: user.uid) { (user) in
          
            if let user = user {
                
                // handle existing user
                User.setCurrent(user)

                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            
                
            } else { //if new user
                
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
                
            }
        }
    }
}
    

