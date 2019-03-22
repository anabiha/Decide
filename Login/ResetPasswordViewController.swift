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
    @IBOutlet weak var resetPassword: loginButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var backToSignIn: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var popup: UIView!
    var dimBackground: UIView!
    var label: UILabel!
    var titleLabel: UILabel!
    //what to do when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configurePopup()
    }
    //end editing once this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        self.email.endEditing(true)
    }
    func configurePopup() {
        //dim background
        dimBackground = UIView(frame: UIScreen.main.bounds)
        dimBackground.alpha = 0
        dimBackground.isHidden = true
        dimBackground.backgroundColor = UIColor.black
        //adding everything in
        popup = UIView(frame: CGRect.zero)
        popup.translatesAutoresizingMaskIntoConstraints = false //important
        let button = loginButton(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popup.addSubview(button)
        popup.addSubview(label)
        popup.addSubview(titleLabel)
        view.addSubview(dimBackground)
        view.addSubview(popup)
        //popup constraints
        popup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popup.topAnchor.constraint(equalTo: dimBackground.topAnchor, constant: 150).isActive = true
        popup.widthAnchor.constraint(equalToConstant: 260).isActive = true
        //titleLabel constraints
        titleLabel.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: popup.topAnchor, constant: 23).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 225).isActive = true
        //label constraints
        label.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: 215).isActive = true
        //button constraints
        button.centerXAnchor.constraint(equalTo: popup.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button.bottomAnchor.constraint(equalTo: popup.bottomAnchor, constant: -15).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 230).isActive = true
        //titleLabel aesthetics
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Sign In"
        //label aesthetics
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = UIColor.gray
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        //button aesthetics
        button.setTitle("Okay", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = button.normalBGColor
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)!
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(self.closePopup(sender:)), for: .touchUpInside)
        //popup aesthetics
        popup.alpha = 0
        popup.backgroundColor = UIColor.white
        popup.layer.cornerRadius = 15
        popup.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        popup.isHidden = true
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
    //make things aesthetic
    func configure() {
        email.delegate = self
        resetPassword.layer.cornerRadius = 10
        resetPassword.layer.masksToBounds = false
        resetPassword.layer.shadowColor = UIColor.lightGray.cgColor
        resetPassword.layer.shadowOpacity = 0.5
        resetPassword.layer.shadowRadius = 10
        resetPassword.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        email.layer.cornerRadius = 10
        resetPassword.backgroundColor = resetPassword.normalBGColor
        defaultFrame = self.view.frame
        
        //allows detection of keyboard appearing/disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
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
            label.numberOfLines = 0
            label.text = "Please enter your email"
            openPopup()
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
                self.label.numberOfLines = 0
                var text = ""
                if let error = error {
                    text = self.rephrase(error: error as NSError)
                } else {
                    text = "Password reset email sent!"
                    self.email.text = ""
                }
                self.label.text = text
                self.openPopup()
            })
        }
    }
}
