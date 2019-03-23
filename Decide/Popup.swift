//
//  Popup.swift
//  Decide
//
//  Created by Daniel Wei on 3/22/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
class Popup: UIView {
    var title: UILabel!
    var label: UILabel!
    var button1: CustomButton!
    var button2: CustomButton?
    var button3: CustomButton?
    private func defaultConfigure() {
        self.translatesAutoresizingMaskIntoConstraints = false //important
        title = UILabel(frame: CGRect.zero)
        title.translatesAutoresizingMaskIntoConstraints = false //important
        label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false //important
        self.addSubview(title)
        self.addSubview(label)
        //popup constraints
        if let view = self.superview {
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.widthAnchor.constraint(equalToConstant: 290).isActive = true
        }
        //title constraints
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 23).isActive = true
        title.widthAnchor.constraint(equalToConstant: 280).isActive = true
        //label constraints
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        label.widthAnchor.constraint(equalToConstant: 280).isActive = true
        //title aesthetics
        title.font = UIFont(name: "AvenirNext-DemiBold", size: 19)
        title.textColor = UIColor.black
        title.lineBreakMode = .byWordWrapping
        title.textAlignment = .center
        title.numberOfLines = 0
        title.text = "Delete Decision"
        //aesthetics
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Are you sure you want to delete this decision?"
        //popup aesthetics
        self.alpha = 0
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.isHidden = true
    }
    func configureThreeButtons() {
        defaultConfigure()
    }
    func configureTwoButtons() {
        defaultConfigure()
        button1 = CustomButton()
        button1.translatesAutoresizingMaskIntoConstraints = false //important
        button2 = CustomButton()
        button2!.translatesAutoresizingMaskIntoConstraints = false //important
      
        self.addSubview(button1)
        self.addSubview(button2!)
        
        //button1 constraints
        button1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -75).isActive = true
        button1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //button2 constraints
        button2!.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 75).isActive = true
        button2!.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button2!.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button2!.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button2!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //button1 aesthetics
        button1.configure(tuple: button.popupCancel)
        //button2 aesthetics
        button2!.configure(tuple: button.popupDelete)
    }
    func configureOneButton() {
        defaultConfigure()
        //instantiate button
        button1 = CustomButton()
        button1.translatesAutoresizingMaskIntoConstraints = false //important
        //add subview
        self.addSubview(button1)
        //button1 constraints
        button1.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 260).isActive = true
        //button1 aesthetics
        button1.configure(tuple: button.popupOkay)
    }
    //programmatically sets a target for a button (basically an IBAction)
    func setButton1Target(_ target: Any?, _ selector: Selector) {
        button1.addTarget(target, action: selector, for: .touchUpInside)
    }
    //programmatically sets a target for a button (basically an IBAction)
    func setButton2Target(_ target: Any?, _ selector: Selector) {
        if let button2 = button2 {
            button2.addTarget(target, action: selector, for: .touchUpInside)
        } else {
            print("BUTTON 2 IS NIL!")
        }
    }
    //programmatically sets a target for a button (basically an IBAction)
    func setButton3Target(_ target: Any?, _ selector: Selector) {
        if let button3 = button3 {
            button3.addTarget(target, action: selector, for: .touchUpInside)
        } else {
            print("BUTTON 3 IS NIL!")
        }
    }
    //sets the title of the popup
    func setTitle(to newTitle: String) {
        title.numberOfLines = 0
        title.text = newTitle
    }
    //sets the text of the popup
    func setText(to newText: String) {
        label.numberOfLines = 0
        label.text = newText
    }
    //switches the style of the button
    func changeButton1(to type: (UIColor, UIColor, UIColor, UIColor, String)) {
        button1.configure(tuple: type)
    }
    //switches the style of the button, must unwrap since button 2 might not exist
    func changeButton2(to type: (UIColor, UIColor, UIColor, UIColor, String)) {
        if let button2 = button2 {
            button2.configure(tuple: type)
        } else {
            print("BUTTON 2 IS NIL!")
        }
    }
    //switches the style of the button, must unwrap since button 2 might not exist
    func changeButton3(to type: (UIColor, UIColor, UIColor, UIColor, String)) {
        if let button3 = button3 {
            button3.configure(tuple: type)
        } else {
            print("BUTTON 3 IS NIL!")
        }
    }
    
}

//button styles!
struct button {
    //tuple: normal bg color, highlighted bg color, normal text color, highlighted text color, title
    static let post = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Post")
    static let logIn = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Sign In")
    static let resetPassword = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Reset Password")
    static let createAccount = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Create Account")
    static let getStarted = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Let's get started!")
    static let popupOkay = (UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Okay")
    static let popupCancel = (UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1), UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1), UIColor.black, UIColor.black,"Cancel")
    static let popupDelete = (UIColor(red: 244/255, green: 66/255, blue: 66/255, alpha: 0.8), UIColor(red: 216/255, green: 41/255, blue: 41/255, alpha: 0.8), UIColor.white, UIColor.white, "Delete")
    static let popupPost = (UIColor(red: 59/255, green: 230/255, blue: 115/255, alpha: 1), UIColor(red: 29/255, green: 209/255, blue: 80/255, alpha: 1), UIColor.white, UIColor.white, "Post")
}

//class that instantiates buttons based on the tuple passed in
class CustomButton: UIButton {
    var normalBGColor: UIColor!
    var selectedBGColor: UIColor!
    //normal bg color, highlighted bg color, normal text color, highlighted text color, title
    func configure(tuple: (UIColor, UIColor, UIColor, UIColor, String)) {
        backgroundColor = tuple.0
        setTitleColor(tuple.2, for: .normal)
        setTitleColor(tuple.3, for: .highlighted)
        setTitleColor(tuple.3, for: .selected)
        setTitle(tuple.4, for: .normal)
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        layer.cornerRadius = 10
        
        self.normalBGColor = tuple.0
        self.selectedBGColor = tuple.1
    }
    func changeTitle(to newTitle: String) {
        setTitle(newTitle, for: .normal)
    }
    //switches color of button when highlighted
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.backgroundColor = self.isHighlighted ? self.selectedBGColor : self.normalBGColor
            })
        }
    }
}
