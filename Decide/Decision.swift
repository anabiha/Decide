//
//  DecisionItem.swift
//  Decide
//
//  Created by Daniel Wei on 11/15/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Decision: DecisionHandler {
    
    var decisionItemList: [String] = []
    
    func configure(withSize size: Int) {
        while decisionItemList.count < size {
            decisionItemList.append("")
        }
    }
    func setTitle(text: String) {
        if decisionItemList.count > 0 {
            decisionItemList[0] = text
        } else {
            decisionItemList.append(text)
        }
    }
    func totalCells() -> Int {
        return decisionItemList.count
    }
    func add(decision: String) {
        decisionItemList.append(decision)
    }
    func removeDecision(at index: Int) {
        if index > 0 && index < decisionItemList.count {
            decisionItemList.remove(at: index)
        } else {
            print("DECISION HANDLER func \"removeDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
        }
    }
    func insertDecision(at index: Int, with decision: String) {
        if index > 0 && index < decisionItemList.count {
            decisionItemList.insert(decision, at: index)
        } else {
            print("DECISION HANDLER func \"insertDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
        }
    }
    func setDecision(at index: Int, with decision: String) {
        if index > 0 && index < decisionItemList.count {
            decisionItemList[index] = decision
        } else {
            print("DECISION HANDLER func \"setDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
        }
    }
    func getDecision(at index: Int) -> String {
        if index > 0 && index < decisionItemList.count {
            return decisionItemList[index]
        } else {
            print("DECISION HANDLER func \"getDecision\" TRIED TO ACCESS OUT OF BOUNDS at index: \(index)")
            return ""
        }
    }
    func getTitle() -> String {
        if decisionItemList.count > 0 {
            return decisionItemList[0]
        } else {
            print("DECISION HANLDER ATTEMPTED TO RETRIEVE A TITLE THAT DIDN'T EXIST")
            return ""
        }
    }
}
protocol DecisionHandler {
    func setTitle(text: String)
    func totalCells() -> Int
    func removeDecision(at index: Int)
    func insertDecision(at index: Int, with decision: String)
    func setDecision(at index: Int, with decision: String)
    func getDecision(at index: Int) -> String
}

class DecisionItem: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var descriptionBox: UITextView!
    let normalBGColor: UIColor = UIColor.white
    let normalBorderColor: CGColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
    let normalTextColor: UIColor = UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1)
    let placeholderColor: UIColor = UIColor(red:200/255, green: 200/255, blue: 200/255, alpha: 0.5)
    let normalFont = UIFont(name: "AvenirNext-DemiBold", size: 25)
    var textViewPlaceholder: UILabel!
    var decisionHandler: DecisionHandler?
    public func configure(text: String?) { //sets everything in the cell up
        descriptionBox.delegate = self //important
        descriptionBox.text = text
        descriptionBox.font = normalFont
            //UIFont.boldSystemFont(ofSize: 25.0)
        descriptionBox.textColor = normalTextColor
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        //let grayColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)//custom color (pretty light grey)
        descriptionBox.backgroundColor = normalBGColor
        descriptionBox.layer.borderColor = normalBorderColor
        descriptionBox.layer.borderWidth = 2
        descriptionBox.layer.cornerRadius = 15
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
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if let index = self.tableView?.indexPath(for: self) {
//
//        }
//
//    }
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
    //restricts number of characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        } else {
           return textView.text.count + (text.count - range.length) <= 65
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
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}

extension UIView { //allows shaking of cells
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 12, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 12, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

extension UITableViewCell { //this is how our cell accesses its own tableview
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
}


class AddButton: UITableViewCell {
    //198, 236, 255
    let normalBGColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 0.2)
    let normalTextColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 1)
        //UIColor(red: 255/255, green: 147/255, blue: 33/155, alpha: 1)
    let greyBG = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 1)
    let greyText = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
    let normalFont = UIFont(name: "AvenirNext-DemiBold", size: 15)
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
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    public func fade(backgroundTo bgColor: UIColor, textTo textColor: UIColor) {
        UIView.animate(withDuration: 0.15, delay: 0, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            self.backgroundColor = bgColor
            self.textLabel?.textColor = textColor
        }, completion: nil)
    }
    public func fadeToGrey() {
        fade(backgroundTo: greyBG, textTo: greyText)
    }
    public func fadeToNormal() {
        fade(backgroundTo: normalBGColor, textTo: normalTextColor)
    }
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
    let normalTextColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 1)
    let placeholderColor = UIColor(red: 86/255, green: 192/255, blue: 249/255, alpha: 1)
    let normalFont = UIFont(name: "AvenirNext-DemiBold", size: 34)
    var decisionHandler: DecisionHandler?
    public func configure(text: String) {
        questionBar.delegate = self
        questionBar.text = text
        questionBar.textColor = normalTextColor
        questionBar.font = normalFont
        questionBar.backgroundColor = normalBGColor
        questionBar.layer.borderColor = UIColor.clear.cgColor
        questionBar.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 10)
        questionBar.layer.cornerRadius = 10
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
    public func fade(backgroundTo bgColor: UIColor) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.questionBar.backgroundColor = bgColor
        }, completion: nil)
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    public func shakeError() {
        self.shake()
    }
}
