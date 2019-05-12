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

class ProfilePopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var subtitle: UILabel!
    var title: UILabel!
    var totalVotes: UILabel!
    var exitButton: CustomButton!
    var deleteButton: CustomButton!
    var post: Post?
    var tableView: UITableView!
    var isShowingPercentages = false
    let width = UIScreen.main.bounds.width - 40
    func configure() {
        clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        subtitle = UILabel() //the header at the top of the popup
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        title = UILabel() //the decision's question
        title.translatesAutoresizingMaskIntoConstraints = false
        totalVotes = UILabel() //label that counts total votes
        totalVotes.translatesAutoresizingMaskIntoConstraints = false
        exitButton = CustomButton() //button to close popup
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton = CustomButton() //button to delete post
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        tableView = UITableView() //tableview that shows all options
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() //hides unused cells
        tableView.separatorStyle = .none
        tableView.register(ProfilePopupCell.self, forCellReuseIdentifier: "cell") //register cell
        //adding subviews
        addSubview(subtitle)
        addSubview(title)
        addSubview(totalVotes)
        addSubview(exitButton)
        addSubview(deleteButton)
        addSubview(tableView)
        //popup constraints
        if let view = superview {
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        //vote question/title constraints
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        title.trailingAnchor.constraint(equalTo: exitButton.leadingAnchor, constant: -24).isActive = true
        //header constraints
        subtitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3).isActive = true
        //vote counter label constraints
        totalVotes.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 40).isActive = true
        totalVotes.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 23).isActive = true
        totalVotes.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        //tableview constriants
        tableView.topAnchor.constraint(equalTo: totalVotes.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        //delete button constraints
        deleteButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        //exit button constraints
        exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //title text
        title.text = ""
        title.textColor = UIColor.black
        title.font = UIFont(name: Universal.heavyFont, size: 23)
        title.lineBreakMode = .byWordWrapping
        title.textAlignment = .left
        //header text
        subtitle.text = "Analytics"
        subtitle.textColor = UIColor.darkText
        subtitle.font = UIFont(name: Universal.lightFont, size: 16)
        //totalvotes text
        totalVotes.text = ""
        totalVotes.textColor = UIColor.darkText
        totalVotes.font = UIFont(name: Universal.heavyFont, size: 18)
        //button config
        exitButton.setBackgroundImage(UIImage(named: "CancelButton"), for: .normal)
        deleteButton.configure(tuple: button.popupDelete)
        //view config
        self.alpha = 0
        self.isHidden = true
        layer.cornerRadius = Universal.cornerRadius
        backgroundColor = UIColor.white
    }
    func setPost(to post: Post) {
        tableView.beginUpdates()
        if self.post != nil {
            let count = self.post!.decisions.count
            tableView.deleteRows(at: (0..<count).map({ (i) in IndexPath(row: i, section: 0)}), with: .none)
        }
        
        self.post = post
        for i in 0..<self.post!.decisions.count {
            tableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .none)
        }
        title.numberOfLines = 0
        title.text = post.title
        totalVotes.text = "Total Votes: \(post.getTotal())"
        tableView.endUpdates()
    }
    
    func setSize(toFrame frame: CGRect) {
        let scaleX = frame.size.width/width
        let scaleY = frame.size.height/300
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    func setExitButtonTarget(_ target: Any?, _ selector: Selector) {
        exitButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func removeExitButtonTargets() {
        exitButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    func setDeleteButtonTarget(_ target: Any?, _ selector: Selector) {
        deleteButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func removeDeleteButtonTargets() {
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if post != nil {
            return post!.decisions.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProfilePopupCell
        if post != nil {
            cell.configure(decision: post!.getDecision(at: indexPath.row), voteCount: post!.getVotes(at: indexPath.row))
        } else {
            print("post is nil")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<post!.decisions.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section)) as? ProfilePopupCell {
                if isShowingPercentages {
                    if post?.totalVotes != 0 {
                        cell.setLabel(to: "\((post!.getPercentage(forDecisionAt: i) * 100).truncate(places: 1)) %")
                    } else {
                        cell.setLabel(to: "No votes")
                    }
                } else {
                    cell.setLabel(to: "\(post!.getVotes(at: i))")
                }
            }
        }
        isShowingPercentages = !isShowingPercentages
    }
    
}
class FlagPopup: UIView, UITextViewDelegate {
    var title: UILabel!
    var reason: UITextView!
    var postButton: CustomButton!
    var data: FlagHandler!
    var text: String!
    var exitButton: CustomButton!
    var placeholder = "Please explain your issue here..."
    func configure(text: String, handler: FlagHandler!) {
        data = handler
        self.text = text
        clipsToBounds = false
        self.translatesAutoresizingMaskIntoConstraints = false //important
        //title instantiation
        title = UILabel(frame: CGRect.zero)
        title.translatesAutoresizingMaskIntoConstraints = false //important
        //textview instantiation
        reason = UITextView()
        reason.delegate = self
        reason.translatesAutoresizingMaskIntoConstraints = false
        //button instantiation
        postButton = CustomButton()
        postButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton = CustomButton()
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        //add subviews
        self.addSubview(title)
        self.addSubview(reason)
        self.addSubview(postButton)
        self.addSubview(exitButton)
        self.bringSubviewToFront(reason)
        //popup constraints
        if let view = self.superview {
            print("Helloo")
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            self.widthAnchor.constraint(equalToConstant: 290).isActive = true
        } else {
            print("FlagPopup;configure(): CALL CONFIGURE AFTER ADDING TO SUPERVIEW")
        }
        //title constraints
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        title.widthAnchor.constraint(equalToConstant: 280).isActive = true
        //table constraints
        reason.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        reason.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        reason.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        reason.heightAnchor.constraint(equalToConstant: 200).isActive = true
        reason.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        //exit button constraints
        exitButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //okay button constraints
        postButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        postButton.topAnchor.constraint(equalTo: reason.bottomAnchor, constant: 20).isActive = true
        postButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        //reason aesthetics
        reason.font = UIFont(name: Universal.lightFont, size: 18)
        reason.textAlignment = .center
        reason.text = placeholder
        reason.textColor = UIColor.lightGray
        reason.selectedTextRange = reason.textRange(from: reason.beginningOfDocument, to: reason.beginningOfDocument)
        //places cursor at beginning
        reason.returnKeyType = .done
        //button aesthetics
        postButton.configure(tuple: button.popupReport)
        exitButton.setBackgroundImage(UIImage(named: "CancelButton"), for: .normal)
        //title aesthetics
        title.font = UIFont(name: Universal.heavyFont, size: 20)
        title.textColor = Universal.blue.withAlphaComponent(0.8)
        title.lineBreakMode = .byWordWrapping
        title.textAlignment = .center
        title.numberOfLines = 0
        title.text = text
        //popup aesthetics
        self.alpha = 0
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = Universal.cornerRadius
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.isHidden = true
    }

    func textViewDidChange(_ textView: UITextView) {
        data.setReason(reason: textView.text)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        //dismiss keyboard upon hitting return key
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        } else if textView.text.count + (text.count - range.length) > 280 {
            return false
        } else if updatedText.isEmpty { //show the placeholder if text is empty
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty { //if the user types something and there's a nonempty string, remove the placeholder and make the textcolor black
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
    //makes the cursor immovable when placeholder is visible
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func clearText() {
        reason.text = placeholder
        reason.textColor = UIColor.lightGray
        reason.selectedTextRange = reason.textRange(from: reason.beginningOfDocument, to: reason.beginningOfDocument)
        reason.endEditing(true)
    }
    func setMainButtonTarget(_ target: Any?, _ selector: Selector) {
        postButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func setExitButtonTarget(_ target: Any?, _ selector: Selector) {
        exitButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func removeMainButtonTargets() {
        postButton.removeTarget(nil, action: nil, for: .allEvents)
    }
    func removeExitButtonTargets() {
        exitButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}
class TagPopup: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var title: UILabel!
    var tagTable: UITableView!
    var postButton: CustomButton!
    var decision: Decision!
    var options: [String]!
    var text: String!
    func configure(text: String, optionList: [String], handler: Decision!) {
        decision = handler
        options = optionList
        self.text = text
        
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
        } else {
            print("TagPopup;configure(): CALL CONFIGURE AFTER ADDING TO SUPERVIEW")
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
        title.font = UIFont(name: Universal.heavyFont, size: 20)
        title.textColor = Universal.blue.withAlphaComponent(0.8)
        title.lineBreakMode = .byWordWrapping
        title.textAlignment = .center
        title.numberOfLines = 0
        title.text = text
        //popup aesthetics
        self.alpha = 0
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = Universal.cornerRadius
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
        let text = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell")!
        cell.textLabel!.text = text
        cell.textLabel?.font = UIFont(name: Universal.mediumFont, size: 18)
        cell.textLabel?.textColor = UIColor.black.withAlphaComponent(0.6)
        cell.selectionStyle = .none
        if decision.isTagged(at: indexPath.row) {
            cell.accessoryType = .checkmark
            cell.backgroundColor = Universal.blue.withAlphaComponent(0.3)
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
                    cell.backgroundColor = Universal.blue.withAlphaComponent(0.3)
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
            
        } else {
            print("Popup;configure(): CALL CONFIGURE AFTER ADDING TO SUPERVIEW")
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
        title.font = UIFont(name: Universal.heavyFont, size: 19)
        title.textColor = UIColor.black
        title.lineBreakMode = .byWordWrapping
        title.textAlignment = .center
        title.numberOfLines = 0
        title.text = "Delete Decision"
        //aesthetics
        label.font = UIFont(name: Universal.lightFont, size: 17)
        label.textColor = UIColor.lightGray
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Are you sure you want to delete this decision?"
        //popup aesthetics
        self.alpha = 0
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = Universal.cornerRadius
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

