//
//  Popup.swift
//  Decide
//
//  Created by Daniel Wei on 3/22/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//  Class for popups
//

import Foundation
import UIKit

class TagPopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var title: UILabel!
    var tagTable: UITableView!
    var postButton: CustomButton!
    var decision: Decision!
    func configure(handler: Decision!) {
        decision = handler
        clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false //important
        
        //title instantiation
        title = UILabel(frame: CGRect.zero)
        title.translatesAutoresizingMaskIntoConstraints = false //important
        //table instantiation
        tagTable = UITableView()
        tagTable.delegate = self
        tagTable.dataSource = self
        tagTable.separatorStyle = .none
        tagTable.contentInsetAdjustmentBehavior = .never
        tagTable.contentInset = UIEdgeInsets.zero
        tagTable.register(UITableViewCell.self, forCellReuseIdentifier: "tagCell") //important bc we didn't use interface builder
        tagTable.translatesAutoresizingMaskIntoConstraints = false
        //button instantiation
        postButton = CustomButton()
        postButton.translatesAutoresizingMaskIntoConstraints = false
        //add subviews
        self.addSubview(title)
        self.addSubview(tagTable)
        self.addSubview(postButton)
        self.bringSubviewToFront(tagTable)
        //popup constraints
        if let view = self.superview {
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.widthAnchor.constraint(equalToConstant: 290).isActive = true
        }
        //title constraints
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        title.widthAnchor.constraint(equalToConstant: 280).isActive = true
        //table constraints
        tagTable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tagTable.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        tagTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        tagTable.heightAnchor.constraint(equalToConstant: 350).isActive = true
        tagTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        //button constraints
        postButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        postButton.topAnchor.constraint(equalTo: tagTable.bottomAnchor, constant: 20).isActive = true
        postButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        //button aesthetics
        postButton.configure(tuple: button.popupOkay)
        //title aesthetics
        title.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        title.textColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.8)
        title.lineBreakMode = .byWordWrapping
        title.textAlignment = .center
        title.numberOfLines = 0
        title.text = "Add up to 2 tags"
        //popup aesthetics
        self.alpha = 0
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 15
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var text = ""
        switch (indexPath.row) {
        case 0:
            text = "Food"
            break
        case 1:
            text = "Sports"
            break
        case 2:
            text = "Education"
            break
        case 3:
            text = "Entertainment"
            break
        case 4:
            text = "Travel"
            break
        case 5:
            text = "Technology"
            break
        case 6:
            text = "Fashion"
            break
        case 7:
            text = "Politics"
            break
        case 8:
            text = "Finances"
            break
        case 9:
            text = "Politics"
            break
        case 10:
            text = "Life Advice"
            break
        case 11:
            text = "Outdoors"
            break
        default:
            text = "Misc"
            break
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell") as! UITableViewCell
        cell.textLabel!.text = text
        cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        cell.textLabel?.textColor = UIColor.black.withAlphaComponent(0.6)
        cell.selectionStyle = .none
        if decision.isTagged(at: indexPath.row) {
            cell.accessoryType = .checkmark
            cell.backgroundColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.3)
        } else {
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped tag at: \(indexPath.row)")
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                UIView.animate(withDuration: 0.1) {
                    cell.backgroundColor = UIColor.white
                }
            } else if decision.numTagged() < 2 {
                cell.accessoryType = .checkmark
                UIView.animate(withDuration: 0.1) {
                    cell.backgroundColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.3)
                }
            }
        }
        decision.markTag(at: indexPath.row) //telling the data structure that this tag was marked
    }
    func setButtonTarget(_ target: Any?, _ selector: Selector) {
        postButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func removeButtonTargets() {
        postButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}
class Popup: UIView {
    var title: UILabel!
    var label: UILabel!
    //popup must contain at least one button
    var button1: CustomButton!
    //next two buttons are optional
    var button2: CustomButton?
    var button3: CustomButton?
    //the default configuration that configures popup, title, and label
    //MUST be called before custom configurations are called
    private func defaultConfigure() {
        clipsToBounds = false
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
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
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
    
    //popup with three buttons
    func configureThreeButtons() {
        defaultConfigure()
        button1 = CustomButton()
        button1.translatesAutoresizingMaskIntoConstraints = false //important
        button2 = CustomButton()
        button2!.translatesAutoresizingMaskIntoConstraints = false //important
        button3 = CustomButton()
        button3!.translatesAutoresizingMaskIntoConstraints = false //important
        self.addSubview(button1)
        self.addSubview(button2!)
        self.addSubview(button3!)
        //button1 constraints
        button1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -98).isActive = true
        button1.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button1.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //button2 constraints
        button2!.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        button2!.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button2!.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button2!.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button2!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //button3 constraints
        button3!.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 98).isActive = true
        button3!.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button3!.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button3!.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button3!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //button1 aesthetics
        button1.configure(tuple: button.popupCancel)
        //button2 aesthetics
        button2!.configure(tuple: button.popupDelete)
        //button3 aesthetics
        button3!.configure(tuple: button.popupOkay)
    }
    //popup with two buttons
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
    //popup with one button
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
    func removeAllTargets() {
        if let button1 = button1 {
            button1.removeTarget(nil, action: nil, for: .allEvents)
        }
        if let button2 = button2 {
            button2.removeTarget(nil, action: nil, for: .allEvents)
        }
        if let button3 = button3 {
            button3.removeTarget(nil, action: nil, for: .allEvents)
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
