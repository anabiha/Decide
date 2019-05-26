//
//  ChangePasswordViewController.swift
//  Decide
//
//  Created by Daniel Wei on 5/25/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    let oldPassword: UITextField = {
        let oldPassword = UITextField()
        oldPassword.backgroundColor = UIColor.white
        oldPassword.textAlignment = .center
        oldPassword.placeholder = "Old Password"
        oldPassword.layer.cornerRadius = Universal.cornerRadius
        oldPassword.translatesAutoresizingMaskIntoConstraints = false
        oldPassword.isSecureTextEntry = true
        oldPassword.textColor = UIColor.darkText
        oldPassword.font = UIFont(name: Universal.lightFont, size: 20)
        return oldPassword
    }()
    let newPassword: UITextField = {
        let newPassword = UITextField()
        newPassword.backgroundColor = UIColor.white
        newPassword.textAlignment = .center
        newPassword.placeholder = "New Password"
        newPassword.layer.cornerRadius = Universal.cornerRadius
        newPassword.translatesAutoresizingMaskIntoConstraints = false
        newPassword.isSecureTextEntry = true
        newPassword.textColor = UIColor.darkText
        newPassword.font = UIFont(name: Universal.lightFont, size: 20)
        newPassword.isHidden = true
        newPassword.alpha = 0
        return newPassword
    }()
    let confirmation: UITextField = {
        let confirmation = UITextField()
        confirmation.backgroundColor = UIColor.white
        confirmation.textAlignment = .center
        confirmation.placeholder = "Confirm New Password"
        confirmation.layer.cornerRadius = Universal.cornerRadius
        confirmation.translatesAutoresizingMaskIntoConstraints = false
        confirmation.isSecureTextEntry = true
        confirmation.textColor = UIColor.darkText
        confirmation.font = UIFont(name: Universal.lightFont, size: 20)
        confirmation.isHidden = true
        confirmation.alpha = 0
        return confirmation
    }()
    let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.textColor = UIColor.darkText
        header.font = UIFont(name: Universal.mediumFont, size: 15)
        header.text = "Change Password"
        return header
    }()
    let backButton: CustomButton = {
        let backButton = CustomButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        return backButton
    }()
    let saveButton: CustomButton = {
        let saveButton = CustomButton()
        saveButton.configure(tuple: button.next)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(nextStep(_:)), for: .touchUpInside)
        return saveButton
    }()
    let popup: Popup = {
        let popup = Popup()
        return popup
    }()
    let dimBackground: UIView = {
        let dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        return dimBackground
    }()
    var saveButtonTop: NSLayoutConstraint!
    var confirmedOldPassword = false
    var createdNewPassword = false
    var confirmedNewPassword = false
    var changedPassword = false
    
    override func viewSafeAreaInsetsDidChange() {
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        header.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        header.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
        
        oldPassword.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30).isActive = true
        oldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        oldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        oldPassword.heightAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true
        
        newPassword.topAnchor.constraint(equalTo: oldPassword.bottomAnchor, constant: 5).isActive = true
        newPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        newPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        newPassword.heightAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true
        
        confirmation.topAnchor.constraint(equalTo: newPassword.bottomAnchor, constant: 5).isActive = true
        confirmation.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        confirmation.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        confirmation.heightAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true
        
        saveButtonTop = saveButton.topAnchor.constraint(equalTo: oldPassword.bottomAnchor, constant: 20)
        saveButtonTop.isActive = true
        
        saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    override func viewDidLoad() {
        view.addSubview(oldPassword)
        view.addSubview(newPassword)
        view.addSubview(confirmation)
        view.addSubview(backButton)
        view.addSubview(saveButton)
        view.addSubview(header)
        view.addSubview(dimBackground)
        view.addSubview(popup)
        
        
        popup.configureOneButton()
        popup.setTitle(to: "Change Password")
        popup.setButton1Target(self, #selector(closePopup(sender:)))
        view.backgroundColor = Universal.viewBackgroundColor
        
        oldPassword.delegate = self
        newPassword.delegate = self
        confirmation.delegate = self
    }
    @objc func goBack(_ sender: Any) {
        oldPassword.endEditing(true)
        newPassword.endEditing(true)
        confirmation.endEditing(true)
        self.performSegue(withIdentifier: "unwindToSettingsOptions", sender: AnyClass.self)
    }
    @objc func nextStep(_ sender: Any) {
        let user = Auth.auth().currentUser
        let email = user?.email
        if !confirmedOldPassword {
            oldPassword.endEditing(true)
            let pw = oldPassword.text ?? ""
            let credential = EmailAuthProvider.credential(withEmail: email ?? "", password: pw)
            user?.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
                var text: String!
                if error != nil { //if error exists
                    print("ChangePasswordViewController; nextStep(): user confirmation failed")
                    text = "Invalid Password. Please try again."
                    self.popup.setText(to: text)
                    self.openPopup()
                    self.oldPassword.text = ""
                } else {
                    //old password authentication successful
                    print("ChangePasswordViewController; nextStep(): user confirmation succeeded")
                    self.oldPassword.isUserInteractionEnabled = false
                    self.confirmedOldPassword = true
                    UIView.animate(withDuration: 0.2, animations: {
                        self.newPassword.isHidden = false
                        self.newPassword.alpha = 1
                    })
                    UIView.animate(withDuration: 0.1, animations: {
                        self.saveButton.transform = CGAffineTransform(translationX: 0, y: self.newPassword.frame.height + 5)
                        print(self.newPassword.frame.height)
                    })
                    self.newPassword.becomeFirstResponder()
                }
            })
        } else if !createdNewPassword {
            if newPassword.text != "" {
                print("ChangePasswordViewController; nextStep(): user typed a new password")
                createdNewPassword = true
                confirmation.endEditing(true)
                UIView.animate(withDuration: 0.2, animations: {
                    self.confirmation.isHidden = false
                    self.confirmation.alpha = 1
                })
                UIView.animate(withDuration: 0.1, animations: {
                    self.saveButton.transform = CGAffineTransform(translationX: 0, y: self.confirmation.frame.height + self.newPassword.frame.height + 10)
                })
                self.confirmation.becomeFirstResponder()
            } else {
                popup.setText(to: "Please enter a new password.")
                openPopup()
            }
        } else if !changedPassword {
            newPassword.endEditing(true)
            confirmation.endEditing(true)
            if confirmation.text == newPassword.text { //passwords match
                if newPassword.text != oldPassword.text { //new password and old password arent the same: try to update it now
                    print("ChangePasswordViewController; nextStep(): passwords match! Trying to change password to: \(confirmation.text ?? "")")
                    newPassword.isUserInteractionEnabled = false
                    confirmation.isUserInteractionEnabled = false
                    user?.updatePassword(to: confirmation.text! , completion: { (error) in
                        if let error = error { //password change failed, probably because password was weak
                            print("ChangePasswordViewController; nextStep(): password change failed")
                            let text = self.rephrase(error: error as NSError)
                            self.popup.setText(to: text)
                            self.openPopup()
                            self.newPassword.isUserInteractionEnabled = true
                            self.confirmation.isUserInteractionEnabled = true
                            self.newPassword.text = ""
                            self.confirmation.text = ""
                        } else { //password change success!
                            print("ChangePasswordViewController; nextStep(): password change successful!")
                            self.changedPassword = true
                            self.popup.setText(to: "Password successfully changed.")
                            self.openPopup()
                            self.popup.setButton1Target(self, #selector(self.goBack(_:)))
                        }
                    })
                } else {
                    popup.setText(to: "New password can't match the old password.")
                    openPopup()
                    newPassword.text = ""
                    confirmation.text = ""
                }
            } else { //passwords don't match
                popup.setText(to: "Passwords don't match.")
                openPopup()
                confirmation.text = ""
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
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
}
