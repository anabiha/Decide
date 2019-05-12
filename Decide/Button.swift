//
//  Button.swift
//  Decide
//
//  Created by Daniel Wei on 5/11/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit

//button styles that can easily be called!
struct button {
    //tuple: normal bg color, highlighted bg color, normal text color, highlighted text color, title
    static let post = (Universal.blue, UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Post")
    static let add = (Universal.blue, UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "+")
    static let logIn = (Universal.blue.withAlphaComponent(0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Sign In")
    static let resetPassword = (Universal.blue.withAlphaComponent(0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Reset Password")
    static let createAccount = (Universal.blue.withAlphaComponent(0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Create Account")
    static let getStarted = (Universal.blue.withAlphaComponent(0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Let's get started!")
    static let popupOkay = (Universal.blue.withAlphaComponent(0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Okay")
    static let popupReport = (Universal.blue.withAlphaComponent(0.8), UIColor(red: 2/255, green: 166/255, blue: 255/255, alpha: 1), UIColor.white, UIColor.white, "Report")
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
        titleLabel?.font = UIFont(name: Universal.heavyFont, size: 16)
        layer.cornerRadius = Universal.cornerRadius
        
        normalBGColor = tuple.0
        selectedBGColor = tuple.1
    }
    func configure(withImage image: UIImage, tuple: (UIColor, UIColor, UIColor, UIColor, String)) {
        backgroundColor = tuple.0
        setTitleColor(tuple.2, for: .normal)
        setTitleColor(tuple.3, for: .highlighted)
        setTitleColor(tuple.3, for: .selected)
        setTitle(tuple.4, for: .normal)
        titleLabel?.font = UIFont(name: Universal.heavyFont, size: 16)
        layer.cornerRadius = Universal.cornerRadius
        self.setImage(image, for: .normal)
        normalBGColor = tuple.0
        selectedBGColor = tuple.1
    }
    //change the title of the button
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

