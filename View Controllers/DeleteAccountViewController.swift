//
//  DeleteAccountViewController.swift
//  Decide
//
//  Created by Daniel Wei on 5/28/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DeleteAccountViewController: UIViewController {
    let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.textColor = UIColor.darkText
        header.font = UIFont(name: Universal.mediumFont, size: 15)
        header.text = "Delete Account"
        return header
    }()
    let backButton: CustomButton = {
        let backButton = CustomButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        return backButton
    }()
    let proceedButton: CustomButton = {
        let proceedButton = CustomButton()
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.configure(tuple: button.proceed)
        proceedButton.addTarget(self, action: #selector(confirmPassword(_:)), for: .touchUpInside)
        return proceedButton
    }()
    var confirmPopup: Popup = {
        let confirmPopup = Popup()
        return confirmPopup
    }()
   
    let dimBackground: UIView = {
        let dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        return dimBackground
    }()
    let text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: Universal.mediumFont, size: 18)
        text.numberOfLines = 0
        text.textAlignment = .center
        text.text = "This will delete your entire Crisp account and the data associated with it."
        return text
    }()
    let password: UITextField = {
        let password = UITextField()
        password.backgroundColor = UIColor.white
        password.textAlignment = .center
        password.placeholder = "Enter your password"
        password.layer.cornerRadius = Universal.cornerRadius
        password.translatesAutoresizingMaskIntoConstraints = false
        password.isSecureTextEntry = true
        password.textColor = UIColor.darkText
        password.font = UIFont(name: Universal.lightFont, size: 18)
        return password
    }()
    override func viewSafeAreaInsetsDidChange() {
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        header.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        header.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 40).isActive = true
        text.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        text.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        
        password.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 40).isActive = true
        password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        password.heightAnchor.constraint(greaterThanOrEqualToConstant: 55).isActive = true
        
        proceedButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20).isActive = true
        proceedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        proceedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        proceedButton.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1)
    }
    override func viewDidLoad() {
        view.addSubview(header)
        view.addSubview(backButton)
        view.addSubview(text)
        view.addSubview(proceedButton)
        view.addSubview(password)
        view.addSubview(dimBackground)
        view.addSubview(confirmPopup)
        view.backgroundColor = Universal.viewBackgroundColor
        confirmPopup.configureOneButton()
        confirmPopup.setTitle(to: "Delete Account")
        confirmPopup.setText(to: "Invalid Password. Please try again.")
        confirmPopup.setButton1Target(self, #selector(closePopup(_:)))
        confirmPopup.changeButton1(to: button.redOkay)
    }
    @objc func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToSettingsOptions", sender: AnyClass.self)
    }
    @objc func deleteAccount(_ sender: Any) {
        let user = Auth.auth().currentUser
        //delete the user's posts from the database
        let ref = Database.database().reference().root
        ref.child("users").child(user!.uid).child("posts").observeSingleEvent(of: .value) { (snapshot) in
            var list: [String] = []
            //retrieve the user's posts
            for case let post as DataSnapshot in snapshot.children {
                let data = post.value as! String
                list.append(data)
            }
            //delete the user's posts
            for post in list {
                ref.child("posts").child(post).removeValue()
            }
            //delete the user from the database
            ref.child("users").child(user!.uid).removeValue()
            
            //delete the user from authentication
            user?.delete(completion: { (error) in
                if let error = error {
                    print(self.rephrase(error: error as NSError))
                } else {
                    print("DeleteAccount; deleteAccount(): Successfully deleted user")
                }
            })
            //present the login view controller
            let vc = UIStoryboard.initialViewController(for: .login)
            self.present(vc, animated: true, completion: nil)
            self.view.window?.rootViewController = vc //make login the root instead of tab bar bc user isn't logged in anymore
        }
    }
    @objc func confirmPassword(_ sender: Any) {
        let user = Auth.auth().currentUser
        let email = user?.email
        password.endEditing(true)
        let pw = password.text ?? ""
        let credential = EmailAuthProvider.credential(withEmail: email ?? "", password: pw)
        user?.reauthenticateAndRetrieveData(with: credential, completion: { (result, error) in
            if error != nil { //if error exists
                print("DeleteAccountViewController; confirmPassword(): user confirmation failed")
                self.openPopup()
                self.password.text = ""
            } else {
                //old password authentication successful
                print("DeleteAccountViewController; confirmPassword(): user confirmation succeeded")
                self.password.isUserInteractionEnabled = false
                //change the popup to the confirmation for deletion
                self.confirmPopup.removeFromSuperview()
                self.confirmPopup = Popup()
                self.view.addSubview(self.confirmPopup)
                self.confirmPopup.configureTwoButtons()
                self.confirmPopup.setTitle(to: "Delete Account")
                self.confirmPopup.setText(to: "Are you sure you want to delete your account? Your data will be erased permanently.")
                self.confirmPopup.setButton1Target(self, #selector(self.goBack(_:)))
                self.confirmPopup.setButton2Target(self, #selector(self.deleteAccount(_:)))
                self.openPopup()
            }
        })
    }
    //opens popup
    func openPopup() {
        self.confirmPopup.isHidden = false
        self.dimBackground.isHidden = false
        UIView.transition(with: confirmPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.confirmPopup.alpha = 1
            self.dimBackground.alpha = 0.5
        }, completion: nil )
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.confirmPopup.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    //objc wrapper for closepopup
    @objc func closePopup(_ sender: Any) {
        closePopup()
    }
    //closes popup
    func closePopup() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.confirmPopup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: nil)
        
        UIView.transition(with: confirmPopup, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.confirmPopup.alpha = 0
            self.dimBackground.alpha = 0
        }, completion: { finished in
            self.confirmPopup.isHidden = true
        })
    }
}
