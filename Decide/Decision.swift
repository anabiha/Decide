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
    var percentage: Double! //might be nil if there have been no votes
    var bar: UIView!
    var fadedBar: UIView! //the default bar
    var decisionLabel: UILabel!
    var voteCountLabel: UILabel!
    var barColor = Universal.blue.withAlphaComponent(0.8)
    var fadedBarColor = Universal.blue.withAlphaComponent(0.1)
    let barHeight: CGFloat = 20
    func configure(decision: String, voteCount: Int, percentage: Double) {
        
        self.percentage = percentage
        self.decision = decision
        self.voteCount = voteCount
        
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
        if bar == nil {
            bar = UIView(frame: CGRect(x: 25, y: self.frame.height - barHeight + 15, width: self.frame.width, height: barHeight))
            bar.layer.cornerRadius = Universal.cornerRadius
            bar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            bar.layer.backgroundColor = barColor.cgColor
            bar.setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0.5))
            bar.transform = CGAffineTransform(scaleX: 0, y: 1)
            bar.isHidden = true
            addSubview(bar)
        }
        if fadedBar == nil {
            fadedBar = UIView(frame: CGRect(x: 25, y: self.frame.height - barHeight + 15, width: self.frame.width, height: barHeight))
            fadedBar.layer.cornerRadius = 10
            fadedBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            fadedBar.layer.backgroundColor = fadedBarColor.cgColor
            addSubview(fadedBar)
        }
        
        decisionLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        decisionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        decisionLabel.bottomAnchor.constraint(equalTo: bar.topAnchor).isActive = true
        decisionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: voteCountLabel.leadingAnchor, constant: -10).isActive = true
       
        voteCountLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        voteCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        voteCountLabel.bottomAnchor.constraint(equalTo: bar.topAnchor).isActive = true
        
        bar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        decisionLabel.text = decision
        decisionLabel.font = UIFont(name: Universal.lightFont, size: 17)
        decisionLabel.textColor = UIColor.darkText
        voteCountLabel.text = "\(voteCount)"
        voteCountLabel.font = UIFont(name: Universal.heavyFont, size: 17)
        voteCountLabel.textColor = UIColor.black
        selectionStyle = .none
    }
    func setLabel(to text: String) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .transitionCrossDissolve, animations: {
            self.voteCountLabel.text = text
        }, completion: nil)
    }
    func displayPercentage() {
        bar.isHidden = false
        //animate bar
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseOut, animations: {
            self.bar.transform = CGAffineTransform(scaleX: CGFloat(self.percentage)/100, y: 1)
        }, completion: nil)
        //animate shifting of choice alpha
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseIn, animations: {
            self.voteCountLabel.alpha = 0
            self.voteCountLabel.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .transitionCrossDissolve, animations: {
            if !self.percentage.isNaN  {
                self.setLabel(to: String("\(self.percentage.truncate(places: 1))%"))
            } else {
                self.setLabel(to: "No votes")
            }
        }, completion: nil)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bar.isHidden = true
        bar.transform = CGAffineTransform(scaleX: 0, y: 1)
    }
}
class ProfileChoiceCell: UITableViewCell {
    var choice: UILabel!
    var decision: String! //the text of the decision
    var bar: UIView?//creates the bar that highlights percentages
    var percentage: Double! //percentage
    var shouldRound = false //decides whether the row should be rounded
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
        choice.font = UIFont(name: Universal.mediumFont, size: 17)
        choice.textColor = UIColor.darkGray
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
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        title.text = text
        title.textColor = UIColor.black
        selectionStyle = .none
        title.font = UIFont(name: Universal.mediumFont, size: 17)
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
        selectionStyle = .none
         clipsToBounds = false
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
        choice.font = UIFont(name: Universal.lightFont, size: 18)
        choice.textColor = UIColor.darkGray
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
        title.textColor = UIColor.darkText
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
        selectionStyle = .none
        clipsToBounds = false
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
    let normalTextColor: UIColor = UIColor.black
    let placeholderColor: UIColor = Universal.lightGrey
//        UIColor(red:240/255, green: 240/255, blue: 240/255, alpha: 1)
    let normalFont = UIFont(name: Universal.lightFont, size: 20)
    var decisionHandler: Decision?
    var placeholder = "Option"
    public func configure(text: String?) { //sets everything in the cell up
        descriptionBox.delegate = self //important
        if text == "" {
            descriptionBox.text = placeholder
            descriptionBox.textColor = placeholderColor
        } else {
            descriptionBox.text = text
            descriptionBox.textColor = normalTextColor
        }
        descriptionBox.font = normalFont
        
        selectionStyle = .none
        //setting the colors of the descriptionBox and row
        descriptionBox.backgroundColor = normalBGColor
        descriptionBox.layer.borderColor = normalBorderColor
        descriptionBox.layer.borderWidth = 2
        descriptionBox.layer.cornerRadius = Universal.cornerRadius
        descriptionBox.textAlignment = .center
        descriptionBox.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
    }
    //tells view controller which cell is currently being edited
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let index = self.tableView!.indexPath(for: self) {
            decisionHandler!.activeFieldIndex = index
        }
        if self.window != nil { //forces the cursor to the beginning
            if textView.textColor == placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        //dismiss keyboard upon hitting return key
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        } else if textView.text.count + (text.count - range.length) > 35 {
            return false
        } else if updatedText.isEmpty { //show the placeholder if text is empty
            textView.text = placeholder
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            decisionHandler!.setDecision(at: getIndexPath()!.section, with: descriptionBox.text)
        } else if textView.textColor == placeholderColor && !text.isEmpty { //if the user types something and there's a nonempty string, remove the placeholder and make the textcolor black
            textView.textColor = normalTextColor
            textView.text = text
            decisionHandler!.setDecision(at: getIndexPath()!.section, with: descriptionBox.text)
            //must set text here as well, since textviewdidchange is not called
        } else {
            return true
        }
        return false
    }
    
    //makes the cursor immovable when placeholder is visible
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
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
    let normalBGColor = UIColor.white
    let normalTextColor = Universal.blue
    let greyBG = Universal.lightGrey
    let greyText = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
    let normalFont = UIFont(name: Universal.mediumFont, size: 25)
    public func configure(BGColor: UIColor, TextColor: UIColor) { //sets everything in the cell up
        //addbutton aesthetics
        textLabel?.text = "+"
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
    let normalTextColor = UIColor.black
    let placeholderColor = Universal.lightGrey
    let normalFont = UIFont(name: Universal.heavyFont, size: 30)
    var decisionHandler: Decision?
    var placeholder = "Ask a question..."
    public func configure(text: String) {
        questionBar.delegate = self
        if text == "" {
            questionBar.text = placeholder
            questionBar.textColor = placeholderColor
        } else {
            questionBar.text = text
            questionBar.textColor = normalTextColor
        }
        questionBar.font = normalFont
        questionBar.backgroundColor = normalBGColor
        questionBar.layer.borderColor = UIColor.clear.cgColor
        questionBar.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        questionBar.layer.cornerRadius = Universal.cornerRadius
        questionBar.textAlignment = .center
        selectionStyle = .none
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        clipsToBounds = true
    }
    //resizes the cell that the textview is in based on text size
    func textViewDidChange(_ textView: UITextView) { //this only works because "scrolling" was disabled in interface builder
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        //dismiss keyboard upon hitting return key
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        } else if textView.text.count + (text.count - range.length) > 80 {
            return false
        } else if updatedText.isEmpty { //show the placeholder if text is empty
            textView.text = placeholder
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            decisionHandler!.setTitle(text: questionBar.text)
        } else if textView.textColor == placeholderColor && !text.isEmpty { //if the user types something and there's a nonempty string, remove the placeholder and make the textcolor black
            textView.textColor = normalTextColor
            textView.text = text
            decisionHandler!.setTitle(text: questionBar.text)
        } else {
            return true
        }
        return false
    }
    //makes the cursor immovable when placeholder is visible
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    //tells the view controller which cell is currently being edited
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        decisionHandler!.activeFieldIndex = IndexPath(row: 0, section: 0)
        if self.window != nil {
            if textView.textColor == placeholderColor {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
        return true
    }
    //method to invoke shake of the cell
    public func shakeError() {
        self.shake()
    }
}
