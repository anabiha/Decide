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
    @IBOutlet weak var resetPassword: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var backToSignIn: UIButton!
    var defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    //what to do when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    //end editing once this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        self.email.endEditing(true)
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
        
        if self.email.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            
            Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    
                    title = "Error!"
                    message = (error?.localizedDescription)!
                    
                } else {
                    
                    title = "Success!"
                    message = "Password reset email sent."
                    
                    self.email.text = ""
                    
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            })
            
            
        }
        
        
    }
    
    @IBAction func goBackToLogin(_ sender: Any) {
        
        let vc = UIStoryboard(type: .login).instantiateInitialViewController()
        
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func goBackToSignUp(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "signup")
        
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
}
