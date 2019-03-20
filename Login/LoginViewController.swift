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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //actions for when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    //hide keyboard and stop editing AFTER this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        self.email.endEditing(true)
        self.password.endEditing(true)
    }
    //make things aesthetic
    func configure() {
        email.delegate = self
        password.delegate = self
        password.isSecureTextEntry = true
        logInButton.layer.cornerRadius = 10
        logInButton.layer.masksToBounds = true
        logInButton.layer.shadowColor = UIColor.lightGray.cgColor
        logInButton.layer.shadowOpacity = 0.5
        logInButton.layer.shadowRadius = 10
        logInButton.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        email.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        
        defaultFrame = self.view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    //shifts view up when keyboard comes up
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let rectInStack = signUpButton.frame
            let rectInView = signUpButton.superview!.convert(rectInStack, to: view)
            if keyboardSize.intersects(rectInView) {
                let offsetDist = rectInView.maxY - keyboardSize.minY + 10
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
    //func to handle unwinding back to this view from other views
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {}
    //preparing to segue to either the sign up page or the reset password page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        //clear text if segueing
        self.email.text = ""
        self.password.text = ""
        switch identifier {
        case "signUpSegue":
            print("SEGUED to signup")
        case "resetSegue":
            print("SEGUED to reset password")
        default:
            print("unexpected segue identifier")
        }
    }
    //action for logging in
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


