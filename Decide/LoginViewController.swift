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
        
        super.viewDidLoad()
        

        

    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //access the FUIAuth default auth UI singleton
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        
        //set FUIAuth's singleton delegate
        authUI.delegate = self
        
        //present the auth view controller
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
        
        //check that the FIRUser returned from authentication is not nil by unwrapping it
        //statement is guarged because we cannot proceed further if the user is not nil
        guard let user = authDataResult?.user
            else{ return }
        
        //contructs the relative path to the refernce of the user's information in our database
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        //read from the path created and pass an event closure to handle the data (snapshot) that is passed back from the database
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
          
            if let user = User(snapshot: snapshot) { //if old user
                
                //handle existing user
                User.setCurrent(user)
                
                //direct them to the Main storyboard
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                
            } else { //else if new user, take them to a page to create a new username
                
                self.performSegue(withIdentifier: "toCreateUsername", sender: self)
                
            }
            
        })
        
    }
}
    

