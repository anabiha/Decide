//
//  CreateUserViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateUserViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var getStarted: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    //what to do when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    //make things aesthetic
    func configure() {
        username.delegate = self
        getStarted.layer.cornerRadius = 10
        getStarted.layer.masksToBounds = false
        getStarted.layer.shadowColor = UIColor.lightGray.cgColor
        getStarted.layer.shadowOpacity = 0.5
        getStarted.layer.shadowRadius = 10
        getStarted.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        username.layer.cornerRadius = 10
        
        defaultFrame = self.view.frame
        
        //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    //shift view up when keyboard appears
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let rect = getStarted.frame
            if rect.intersects(keyboardSize) {
                let offsetDist = rect.maxY - keyboardSize.minY + 80
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -offsetDist)
            }
        }
    }
    //shift view down when keyboard disappears
    @objc func keyboardWillHide(_ notification:Notification) {
        self.view.frame = defaultFrame
    }
    //hide keyboard when user presses return key
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    //action to go to main screen
    @IBAction func goToMainScreen(_ sender: Any) {
        username.endEditing(true)
        // if the user leaves the email field, text field, or both blank, have a popup
        if username.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter a username", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            //add the username to the database
            let ref = Database.database().reference().root
            guard let userKey = Auth.auth().currentUser?.uid else {return}
            ref.child("users").child(userKey).child("username").setValue(username.text)
            
            // ask if the user wants to add a profile picture
            let alertController = UIAlertController(title: "Profile Picture", message: "Would you like to add a profile picture?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                
                // bring up image picker to allow user to either pick a photo from the photo gallery or take a picture for their profile picture
                let photoHelper = PhotoHelper()
                
                photoHelper.completionHandler = { image in
                    
                    print("handle image")
                    
                }
                
                photoHelper.presentActionSheet(from: self)
                
                //add the profile image to the database
                
                // go to home page
                
                let vc = UIStoryboard(type: .main).instantiateInitialViewController()
                
                self.present(vc!, animated: true, completion: nil)
                
            }))
            
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                
                //proceed to home page
                let vc = UIStoryboard(type: .main).instantiateInitialViewController()
                
                self.present(vc!, animated: true, completion: nil)
                
            }))
            
            present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    
    
}
