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
    
    @IBOutlet weak var logInButton: CustomButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    var popup: Popup!
    var dimBackground: UIView!
    //the initialframe of the view
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
        logInButton.configure(tuple: button.logIn)
        logInButton.layer.masksToBounds = false
        logInButton.layer.shadowColor = UIColor.lightGray.cgColor
        logInButton.layer.shadowOpacity = 0.5
        logInButton.layer.shadowRadius = 10
        logInButton.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        email.layer.cornerRadius = Universal.cornerRadius
        password.layer.cornerRadius = Universal.cornerRadius
        defaultFrame = self.view.frame
         //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //add popup
        popup = Popup()
        view.addSubview(popup)
        popup.configureOneButton()
        popup.setTitle(to: "Sign In")
        popup.setButton1Target(self, #selector(self.closePopup(sender:)))
        //dim background
        dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        view.addSubview(dimBackground)
        //bring views to front
        view.bringSubviewToFront(dimBackground)
        view.bringSubviewToFront(popup)
        view.backgroundColor = Universal.viewBackgroundColor
    }
    @objc func closePopup(sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .transitionCrossDissolve, animations: {
            self.popup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        UIView.transition(with: self.popup, duration: 0.15, options: .transitionCrossDissolve, animations: {
            self.popup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.popup.isHidden = true
            self.dimBackground.isHidden = true
        })
    }
    func openPopup() {
        popup.isHidden = false
        dimBackground.isHidden = false
        //fade it in while also zooming in
        UIView.transition(with: popup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.popup.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.popup.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
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
        email.endEditing(true)
        password.endEditing(true)
        if self.email.text == "" && self.password.text == "" {
            popup.setText(to: "Please enter your email and password.")
            openPopup()
        } else if self.email.text == ""{
            popup.setText(to: "Please enter your email.")
            openPopup()
        } else if self.password.text == "" {
            popup.setText(to: "Please enter your password.")
            openPopup()
        } else {
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                if let error = error {
                    self.popup.setText(to: self.rephrase(error: error as NSError))
                    self.openPopup()
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


