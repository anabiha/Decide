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
extension UIViewController {
    func rephrase(error: NSError) -> String {
        switch (error.code) {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Please enter a valid email."
        case AuthErrorCode.userNotFound.rawValue:
            return "Invalid username or password. Please try again."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Invalid username or password. Please try again."
        default:
            return error.localizedDescription
        }
    }
}
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    var popup: UIView!
    var dimBackground: UIView!
    var label: UILabel!
    var titleLabel: UILabel!
    //the initialframe of the view
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //actions for when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configurePopup()
    }
    //hide keyboard and stop editing AFTER this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        self.email.endEditing(true)
        self.password.endEditing(true)
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
        let button = UIButton(frame: CGRect.zero)
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
        button.backgroundColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 1)
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
        email.endEditing(true)
        password.endEditing(true)
        if self.email.text == "" && self.password.text == "" {
            label.numberOfLines = 0
            label.text = "Please enter your email and password"
            openPopup()
        } else if self.email.text == ""{
            
            label.numberOfLines = 0
            label.text = "Please enter your email"
            openPopup()
        } else if self.password.text == "" {
            
            label.numberOfLines = 0
            label.text = "Please enter your password"
            openPopup()
        } else {
            Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
                if let error = error {
                    self.label.numberOfLines = 0
                    self.label.text = self.rephrase(error: error as NSError)
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


