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
    @IBOutlet weak var getStarted: CustomButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var popup: Popup!
    var dimBackground: UIView!
    //what to do when view loads
    override func viewDidLoad() {
        configure()
    }
    //make things aesthetic
    func configure() {
        username.delegate = self
        getStarted.configure(tuple: button.getStarted)
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
        //add popup
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
            popup.setText(to: "Please enter a username.")
            openPopup()
            
        } else {
            
            // writing user to the database
            let ref = Database.database().reference()
            guard let userKey = Auth.auth().currentUser?.uid else {return}
            
            ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
                var validName = true
                //checking for a name that hasn't been taken
                for case let user as DataSnapshot in snapshot.children  {
                    for case let name as DataSnapshot in user.children {
                        if let unwrapped = name.value as? String {
                            if self.username.text! == unwrapped {
                                validName = false
                            }
                        }
                    }
                }
                if validName {
                    ref.child("users").child(userKey).child("username").setValue(self.username.text!)
                    let vc = UIStoryboard(type: .main).instantiateInitialViewController()
                    self.present(vc!, animated: true, completion: nil)
                } else { //if username does not already exist
                    self.popup.setText(to: "This username is already taken.")
                    self.openPopup()
                }
            }, withCancel: nil)
        }
    }
    
}
