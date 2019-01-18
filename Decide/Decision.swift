//
//  DecisionItem.swift
//  Decide
//
//  Created by Daniel Wei on 11/15/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
class Decision {
    var decisionTitle: String = ""
    var decisionItemList: [DecisionItem] = []
}

class DecisionItem: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var descriptionBox: UITextField!
    var decisionItemTitle: String = ""
    
    public func configure(text: String?, placeholder: String) { //sets everything in the cell up
        descriptionBox.delegate = self
        
        descriptionBox.text = text
        descriptionBox.font = UIFont.boldSystemFont(ofSize: 15.0)
        descriptionBox.placeholder = placeholder
        descriptionBox.accessibilityValue = text
        descriptionBox.accessibilityLabel = placeholder
       // descriptionBox.setLeftPaddingPoints(15); //see UITextField extension below
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        let grayColor2 = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)//custom color (even lighter gray)
        descriptionBox.backgroundColor = grayColor2
        descriptionBox.layer.cornerRadius = 20
        
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 15
        clipsToBounds = true
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldDidChange(textField)
        return true
    }
    func textFieldDidChange(_ textField: UITextField) { //FIX
        let fixedWidth = textField.frame.size.width
        textField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textField.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textField.frame = newFrame
    }
}
class AddButton: UITableViewCell {
    public func configure() { //sets everything in the cell up
        //addbutton aesthetics
        textLabel?.text = "+ Add an item"
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        textLabel?.textAlignment = .center
        // add border and color
        let grayColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)//custom color (pretty light gray)
        backgroundColor = grayColor
        layer.borderColor = grayColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}
extension UITextField: UITextFieldDelegate { //allows padding of UITextFields
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
