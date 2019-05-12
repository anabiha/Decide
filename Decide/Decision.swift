//
//  DecisionItem.swift
//  Decide
//
//  Created by Daniel Wei on 11/15/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
class ProfilePopupCell: UITableViewCell {
    var decision: String!
    var voteCount: Int!
    var decisionLabel: UILabel!
    var voteCountLabel: UILabel!
    func configure(decision: String, voteCount: Int) {
       
        if decisionLabel == nil {
            decisionLabel = UILabel()
            decisionLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(decisionLabel)
        }
        if voteCountLabel == nil {
            voteCountLabel = UILabel()
            voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(voteCountLabel)
        }
        
        decisionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        decisionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        decisionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: voteCountLabel.leadingAnchor, constant: -10).isActive = true
        
        voteCountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        voteCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        decisionLabel.text = decision
        decisionLabel.font = UIFont(name: Universal.lightFont, size: 16)
        decisionLabel.textColor = UIColor.darkText
        voteCountLabel.text = "\(voteCount)"
        voteCountLabel.font = UIFont(name: Universal.heavyFont, size: 16)
        voteCountLabel.textColor = UIColor.black
        selectionStyle = .none
    }
    func setLabel(to text: String) {
        voteCountLabel.text = text
    }
}
class ProfileChoiceCell: UITableViewCell {
    var choice: UILabel!
    var decision: String! //the text of the decision
    var bar: UIView?//creates the bar that highlights percentages
    var percentage: Double! //percentage
    var shouldRound = false //decides whether the row should be rounded
    var color1 = UIColor.white
    //default color
    var color2 = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)  //the color of what was chosen
    var barColor = Universal.blue.withAlphaComponent(0.2) //color of bar
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldRound {
            roundCorners([.bottomLeft, .bottomRight], radius: Universal.cornerRadius)
        } else {
            roundCorners([.bottomLeft, .bottomRight], radius: 0)
        }
    }
    func configure(text: String, percentage: Double, color: UIColor) {
        //make sure subviews to leave the view
        selectionStyle = .none
        if choice == nil {
            choice = UILabel()
            addSubview(choice)
        }
        choice.translatesAutoresizingMaskIntoConstraints = false
        choice.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        choice.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        choice.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        choice.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        choice.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        //set the information
        choice.text = text
        decision = text
        self.percentage = percentage
        //bar
        if bar == nil {
            bar = UIView(frame: self.frame)
            bar!.sizeToFit()
            self.addSubview(bar!)
            bar!.layer.backgroundColor = barColor.cgColor
            bar!.isHidden = true
            bar!.alpha = 0
            bar!.frame.size.width = 0
        }
        self.sendSubviewToBack(bar!)
        //cell aesthetics
        backgroundColor = color
        //label aesthetics
        choice.backgroundColor = UIColor.clear
        choice.font = UIFont(name: Universal.mediumFont, size: 16)
        choice.textColor = Universal.blue
        choice.textAlignment = .center
    }
    func updatePercent(newPercent: Double) {
        percentage = newPercent
    }
    func displayText() {
        if let bar = bar {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                bar.alpha = 0
                bar.frame.size.width = 0
                self.choice.alpha = 0
            })
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                self.choice.alpha = 1
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                self.choice.text = self.decision
            })
        }
    }
    func displayPercentage() {
        if let bar = bar {
            bar.isHidden = false
            //animate bar
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
                bar.alpha = 1
                bar.frame.size.width = self.frame.size.width * CGFloat(self.percentage)
            }, completion: nil)
            //animate shifting of choice alpha
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
                self.choice.alpha = 0
                self.choice.alpha = 1
            }, completion: nil)
            UIView.animate(withDuration: 0.1, delay: 0.2, options: .transitionCrossDissolve, animations: {
                self.choice.text = String("\((self.percentage * 100).truncate(places: 1))%") //this step must happen before the shift of choice, otherwise animation wont work
            }, completion: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bar!.isHidden = true
        bar!.alpha = 0
        bar!.frame.size.width = 0
    }
}
class ProfileTitleCell: UITableViewCell {
    var title: UITextView!
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight], radius: Universal.cornerRadius)
    }
    func configure(text: String) {
        if title == nil {
            title = UITextView()
            addSubview(title)
            
        }
        title.translatesAutoresizingMaskIntoConstraints = false
        title.isUserInteractionEnabled = false
        title.isScrollEnabled = false
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        title.text = text
        title.textColor = UIColor.black
        selectionStyle = .none
        title.font = UIFont(name: Universal.mediumFont, size: 18)
        title.textAlignment = .center
    }
}
class HomeChoiceCell: UITableViewCell {
    @IBOutlet weak var choice: UILabel!
    var decision: String! //the text of the decision
    var bar: UIView?//creates the bar that highlights percentages
    var percentage: Double! //percentage
    var shouldRound = false //decides whether the row should be rounded
    var color1 = UIColor.white
        //default color
    var color2 = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)  //the color of what was chosen
    var barColor = Universal.blue.withAlphaComponent(0.2) //color of bar
    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldRound {
            roundCorners([.bottomLeft, .bottomRight], radius: Universal.cornerRadius)
        } else {
            roundCorners([.bottomLeft, .bottomRight], radius: 0)
        }
    }
    func configure(text: String, percentage: Double, color: UIColor) {
        //make sure subviews to leave the view
        clipsToBounds = true
        selectionStyle = .none
        //set the information
        choice.text = text
        decision = text
        self.percentage = percentage
        //bar
        if bar == nil {
            bar = UIView(frame: self.frame)
            bar!.sizeToFit()
            self.addSubview(bar!)
            bar!.layer.backgroundColor = barColor.cgColor
            bar!.isHidden = true
            bar!.alpha = 0
            bar!.frame.size.width = 0
        }
        self.sendSubviewToBack(bar!)
        //cell aesthetics
        backgroundColor = color
        //label aesthetics
        choice.backgroundColor = UIColor.clear
        choice.font = UIFont(name: Universal.lightFont, size: 15)
        choice.textColor = Universal.blue //color of bar
        choice.textAlignment = .center
    }
    func updatePercent(newPercent: Double) {
        percentage = newPercent
    }
    func displayText() {
        if let bar = bar {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                bar.alpha = 0
                bar.frame.size.width = 0
                self.choice.alpha = 0
            })
            UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
               self.choice.alpha = 1
            })
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .transitionCrossDissolve], animations: {
                self.choice.text = self.decision
            })
        }
    }
    func displayPercentage() {
        if let bar = bar {
            bar.isHidden = false
            //animate bar
            UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
                bar.alpha = 1
                bar.frame.size.width = self.frame.size.width * CGFloat(self.percentage)
            }, completion: nil)
            //animate shifting of choice alpha
            UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
                self.choice.alpha = 0
                self.choice.alpha = 1
            }, completion: nil)
            UIView.animate(withDuration: 0.1, delay: 0.2, options: .transitionCrossDissolve, animations: {
                self.choice.text = String("\((self.percentage * 100).truncate(places: 1))%") //this step must happen before the shift of choice, otherwise animation wont work
            }, completion: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bar!.isHidden = true
        bar!.alpha = 0
        bar!.frame.size.width = 0
    }
}

class HomeTitleCell: UITableViewCell {
    @IBOutlet weak var title: UITextView!
    func configure(text: String) {
        title.text = text
        title.textColor = UIColor.black
        selectionStyle = .none
        title.font = UIFont(name: Universal.mediumFont, size: 18)
        title.textAlignment = .center
    }
}
class UserCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var flagButton: CustomButton!
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners([.topLeft, .topRight], radius: Universal.cornerRadius)
    }
    func configure(username: String) {
        clipsToBounds = true
        selectionStyle = .none
        self.username.text = username
        self.username.textAlignment = .center
        self.username.font = UIFont(name: Universal.heavyFont, size: 16)
        backgroundColor = UIColor.white
    }
    func setButtonTarget(_ target: Any?, _ selector: Selector) {
        flagButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    func removeButtonTargets() {
        flagButton.removeTarget(nil, action: nil, for: .allEvents)
    }
}


class DecisionItem: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var descriptionBox: UITextView!
    let normalBGColor: UIColor = UIColor.white
    let normalBorderColor: CGColor = UIColor.white.cgColor
    let normalTextColor: UIColor = UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1)
    let placeholderColor: UIColor = UIColor(red:240/255, green: 240/255, blue: 240/255, alpha: 1)
    let normalFont = UIFont(name: Universal.lightFont, size: 25)
    var textViewPlaceholder: UILabel!
    var decisionHandler: Decision?
    public func configure(text: String?) { //sets everything in the cell up
        descriptionBox.delegate = self //important
        descriptionBox.text = text
        descriptionBox.font = normalFont
        descriptionBox.textColor = normalTextColor
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        descriptionBox.backgroundColor = normalBGColor
        descriptionBox.layer.borderColor = normalBorderColor
        descriptionBox.layer.borderWidth = 2
        descriptionBox.layer.cornerRadius = Universal.cornerRadius
        descriptionBox.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        
        textViewPlaceholder = UILabel()
        textViewPlaceholder.font = normalFont
        textViewPlaceholder.textColor = placeholderColor
        textViewPlaceholder.text = "Option"
        textViewPlaceholder.sizeToFit()
        textViewPlaceholder.isHidden = !descriptionBox.text.isEmpty
        textViewPlaceholder.frame.origin = CGPoint(x: 12, y: (descriptionBox.font?.pointSize)! / 2 - 3)
        descriptionBox.addSubview(textViewPlaceholder)
        
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        clipsToBounds = true //important
    }
    //tells view controller which cell is currently being edited
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let index = self.tableView!.indexPath(for: self) {
            decisionHandler!.activeFieldIndex = index
        }
        return true
    }
    //tells tableview to shift
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let size = decisionHandler!.keyboardSize {
            shift(keyboardSize: size)
        }
    }
    //moves tableview accordingly
    func shift(keyboardSize: CGRect) {
        if let index = decisionHandler!.activeFieldIndex {
            let rectInTable = self.tableView!.rectForRow(at: index)
            let rectInView = self.tableView!.convert(rectInTable, to: self.tableView!.superview)
            if keyboardSize.intersects(rectInView) {
                print("intersects")
                let dist = rectInView.maxY - keyboardSize.minY + 30
                UIView.animate(withDuration: 0.25) {
                    self.tableView!.contentInset.bottom = dist + self.tableView!.contentInset.bottom
                    self.tableView!.contentOffset.y = self.tableView!.contentOffset.y + dist
                }
            }
        }
    }
    //changes cell height while text is changing
    func textViewDidChange(_ textView: UITextView) { //this only works because "scrolling" was disabled in interface builder
        textViewPlaceholder.isHidden = !descriptionBox.text.isEmpty
        let startHeight = textView.frame.size.height
        let fixedWidth = textView.frame.size.width
        let newSize =  textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if (startHeight != newSize.height) {
            UIView.setAnimationsEnabled(false) // Disable animations
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        decisionHandler!.setDecision(at: getIndexPath()!.section, with: descriptionBox.text)
    }
    //restricts number of characters, hide keyboard when pressing return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        } else {
            return textView.text.count + (text.count - range.length) <= 35
        }
    }
    //shifts color of background
    public func fade(backgroundTo bgColor: UIColor, borderTo borderColor: CGColor) {
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.descriptionBox.backgroundColor = bgColor
            self.descriptionBox.layer.borderColor = borderColor
        }, completion: nil)
    }
    //creates the animation for error
    public func shakeError() {
        let errorRed = UIColor(red: 244/255, green: 66/255, blue: 66/255, alpha: 0.7)
        fade(backgroundTo: errorRed, borderTo: errorRed.cgColor)
        self.shake()
        fade(backgroundTo: normalBGColor, borderTo: normalBorderColor)
    }
    //get cell's indexpath
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

class AddButton: UITableViewCell {
    //198, 236, 255
    let normalBGColor = Universal.blue.withAlphaComponent(0.2)
    let normalTextColor = Universal.blue
    //UIColor(red: 255/255, green: 147/255, blue: 33/155, alpha: 1)
    let greyBG = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
    let greyText = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
    let normalFont = UIFont(name: Universal.mediumFont, size: 15)
    public func configure(BGColor: UIColor, TextColor: UIColor) { //sets everything in the cell up
        //addbutton aesthetics
        textLabel?.text = "+ Add an item"
        textLabel?.font = normalFont
        textLabel?.textAlignment = .center
        textLabel?.textColor = TextColor
        selectionStyle = .none
        backgroundColor = BGColor
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = Universal.cornerRadius
        clipsToBounds = true
    }
    //changes color of textview
    public func fade(backgroundTo bgColor: UIColor, textTo textColor: UIColor) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            self.backgroundColor = bgColor
            self.textLabel?.textColor = textColor
        }, completion: nil)
    }
    //changes color to grey
    public func fadeToGrey() {
        fade(backgroundTo: greyBG, textTo: greyText)
    }
    //changes color to normal color
    public func fadeToNormal() {
        fade(backgroundTo: normalBGColor, textTo: normalTextColor)
    }
    //custom frame
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            let inset: CGFloat = 10
            var frame = newFrame
            frame.origin.x += inset
            frame.size.width -= 2 * inset
            super.frame = frame
        }
    }
    
}

class QuestionBar: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var questionBar: UITextView!
    var textViewPlaceholder: UILabel!
    let normalBGColor = UIColor.clear
    let normalTextColor = Universal.blue
    let placeholderColor = Universal.blue
    let normalFont = UIFont(name: Universal.heavyFont, size: 30)
    var decisionHandler: Decision?
    public func configure(text: String) {
        questionBar.delegate = self
        questionBar.text = text
        questionBar.textColor = normalTextColor
        questionBar.font = normalFont
        questionBar.backgroundColor = normalBGColor
        questionBar.layer.borderColor = UIColor.clear.cgColor
        questionBar.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 10)
        questionBar.layer.cornerRadius = Universal.cornerRadius
        selectionStyle = .none
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        
        textViewPlaceholder = UILabel() //places a UILabel over the question bar to make a placeholder
        textViewPlaceholder.font = normalFont
        textViewPlaceholder.textColor = placeholderColor
        textViewPlaceholder.text = "Ask a question..."
        textViewPlaceholder.sizeToFit()
        textViewPlaceholder.isHidden = !questionBar.text.isEmpty
        questionBar.addSubview(textViewPlaceholder)
        textViewPlaceholder.frame.origin = CGPoint(x: 5, y: (questionBar.font?.pointSize)! / 2 - 12)
        
        clipsToBounds = true
    }
    //resizes the cell that the textview is in based on text size
    func textViewDidChange(_ textView: UITextView) { //this only works because "scrolling" was disabled in interface builder
        textViewPlaceholder.isHidden = !questionBar.text.isEmpty
        let startHeight = textView.frame.size.height
        let fixedWidth = textView.frame.size.width
        let newSize =  textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if (startHeight != newSize.height) {
            UIView.setAnimationsEnabled(false) // Disable animations
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        decisionHandler!.setTitle(text: questionBar.text)
    }
    //shifts color of textview
    public func fade(backgroundTo bgColor: UIColor) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.questionBar.backgroundColor = bgColor
        }, completion: nil)
    }
    //hides keyboard when pressing return
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        } else {
            return textView.text.count + (text.count - range.length) <= 80
        }
    }
    //tells the view controller which cell is currently being edited
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        decisionHandler!.activeFieldIndex = IndexPath(row: 0, section: 0)
        return true
    }
    //method to invoke shake of the cell
    public func shakeError() {
        self.shake()
    }
}
