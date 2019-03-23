//
//  ResetPasswordViewController.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var resetPassword: CustomButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var backToSignIn: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var popup: Popup!
    var dimBackground: UIView!
    //what to do when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    //make things aesthetic
    func configure() {
        email.delegate = self
        resetPassword.configure(tuple: button.resetPassword)
        resetPassword.layer.masksToBounds = false
        resetPassword.layer.shadowColor = UIColor.lightGray.cgColor
        resetPassword.layer.shadowOpacity = 0.5
        resetPassword.layer.shadowRadius = 10
        resetPassword.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        email.layer.cornerRadius = 10
        defaultFrame = self.view.frame
        
        //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        popup = Popup()
        view.addSubview(popup)
        popup.configureOneButton()
        popup.setTitle(to: "Reset Password")
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
    //end editing once this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        self.email.endEditing(true)
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
            let rect = backToSignIn.frame
            if rect.intersects(keyboardSize) {
                let offsetDist = rect.maxY - keyboardSize.minY + 50
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -offsetDist)
            }
        }
    }
    //shift view down when keyboard disappearw
    @objc func keyboardWillHide(_ notification:Notification) {
        self.view.frame = defaultFrame
    }
    //hide keyboard when user pressed return
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    //preparing to segue back to login screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        self.email.text = ""
        switch identifier {
        case "loginSegue":
            print("SEGUED to login")
        default:
            print("unexpected segue identifier")
        }
    }
    //action to reset password
    @IBAction func resetPassword(_ sender: Any) {
        email.endEditing(true)
        if self.email.text == "" {
            popup.setText(to: "Please enter your email.")
            openPopup()
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
                var text = ""
                if let error = error {
                    text = self.rephrase(error: error as NSError)
                } else {
                    text = "Password reset email sent!"
                    self.email.text = ""
                }
                self.popup.setText(to: text)
                self.openPopup()
            })
        }
    }
}
