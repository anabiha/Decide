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

class SignUpViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var createAccount: CustomButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signIn: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var popup: Popup!
    var dimBackground: UIView!
   
    override func viewDidLoad() {
        configure()
        super.viewDidLoad()
        configure()
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
        createAccount.configure(tuple: button.createAccount)
        createAccount.layer.masksToBounds = false
        createAccount.layer.shadowColor = UIColor.lightGray.cgColor
        createAccount.layer.shadowOpacity = 0.5
        createAccount.layer.shadowRadius = 10
        createAccount.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        email.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        defaultFrame = self.view.frame
         //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //add in popup
        popup = Popup()
        view.addSubview(popup)
        popup.configureOneButton()
        popup.setTitle(to: "Sign Up")
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
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            return true
        } else { return false }
    }
    @IBAction func createAccount(_ sender: Any) {
        // if the user leaves the email field, text field, or both blank, have a popup
        email.endEditing(true)
        password.endEditing(true)
        if email.text == "" && password.text == "" {
            popup.setText(to: "Please enter an email and password.")
            openPopup()
        } else if email.text == "" {
            popup.setText(to: "Please enter an email.")
            openPopup()
        } else if password.text == "" {
            popup.setText(to: "Please enter a password.")
            openPopup()
        } else {
            // writing user to the database
            let ref = Database.database().reference().root
            // creates a user account in firebase
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                // check to see if there is any sign up error
                if let error = error {
                    self.popup.setText(to: self.rephrase(error: error as NSError))
                    self.openPopup()
                } else {
                    print("SUCCESSFULLY SIGNED UP")
                    ref.child("users").child((user?.user.uid)!).setValue(self.email.text)
                    self.performSegue(withIdentifier: "createUserSegue", sender: self)
                }
            })
        }
        
    
        
    }

    
  
    
    

}
