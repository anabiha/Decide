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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //what to do when view loads (DON'T USE VIEWWILLAPPEAR)
    override func viewDidLoad() {
        configure()
        super.viewDidLoad()
        
    }
    
    
    //what to do when view is about to disappear
    override func viewWillDisappear(_ animated: Bool) {
        
        self.email.endEditing(true)
        self.password.endEditing(true)
        
    }
    
    //make things aesthetic
    func configure() {
        password.isSecureTextEntry = true
        email.delegate = self
        password.delegate = self
        createAccount.layer.cornerRadius = 10
        createAccount.layer.masksToBounds = false
        createAccount.clipsToBounds = true
        createAccount.layer.shadowColor = UIColor.lightGray.cgColor
        createAccount.layer.shadowOpacity = 0.5
        createAccount.layer.shadowRadius = 10
        createAccount.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        email.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        
         defaultFrame = self.view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
     //shifts view up when keyboard comes up
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let rect = signIn.superview!.frame
            if rect.intersects(keyboardSize) {
                let offsetDist = rect.maxY - keyboardSize.minY + 20
                self.view.frame = defaultFrame.offsetBy(dx: 0, dy: -offsetDist)
            }
        }
    }
    
    //shifts view down when keyboard goes away
    @objc func keyboardWillHide(_ notification:Notification) {
        self.view.frame = defaultFrame
    }
    
    //makes the keyboard disappear when pressing return
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    //preparing to segue back to the login page or to the create user page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
            switch identifier {
            case "loginSegue":
                print("SEGUED to login") //clear these fields if going back to login page
                self.email.text = ""
                self.password.text = ""
            case "createUserSegue":
                 print("SEGUED to create user")
            default:
                print("unexpected segue identifier")
            }
    }
    
    func isEmailAndPasswordCorrrectlyFormatted() -> Bool {
        
        var isFormattedCorrectly = true
        
        // if the user leaves the email field blank, have a popup
        if email.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            // writing user to the database
            let ref = Database.database().reference().root
            
            // creates a user account in firebase
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                
                // check to see if there is any sign up error
                if error != nil {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    isFormattedCorrectly = false
                    
                    
                } else {
                    
                    print("You have successfully signed up")
                    
                    ref.child("users").child((user?.user.uid)!).setValue(self.email.text)
                    
                    // goes to the setup page which lets the user take a photo for their profile picture and create a username
                    //  let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "createUser") as UIViewController
                    
                    //  self.present(viewController, animated: false, completion: nil)
                    
                }
            }
        }
        
        return isFormattedCorrectly
        
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var shouldContinue = true
        
        if identifier == "createUserSegue" {
            
            shouldContinue = isEmailAndPasswordCorrrectlyFormatted()
           
        }
        
        return shouldContinue
        
    }
    
  
    
    

}
