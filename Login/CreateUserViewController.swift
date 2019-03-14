//
//  CreateUserViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        
    }
    
    @IBOutlet weak var username: UITextField!
    
    
    @IBAction func goToMainScreen(_ sender: Any) {
        
        // if the user leaves the email field, text field, or both blank, have a popup
        if username.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter a username", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            // ask if the user wants to add a profile picture
            let alertController = UIAlertController(title: "Profile Picture", message: "Would you like to add a profile picture?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                // bring up image picker to allow user to either pick a photo from the photo gallery or take a picture for their profile picture
                let photoHelper = PhotoHelper()
                
                photoHelper.completionHandler = { image in
                    
                    print("handle image")
                    
                }
                
                photoHelper.presentActionSheet(from: self)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            // if everything is alright, proceed to home page
            let vc = UIStoryboard(type: .main).instantiateInitialViewController()
            
            self.present(vc!, animated: true, completion: nil)
            
        }
        
    }
    
    
}
