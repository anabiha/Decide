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

class DecisionItem: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var descriptionBox: UITextView!
    let normalBGColor: UIColor = UIColor.white
    let normalBorderColor: CGColor = UIColor.black.cgColor
    var textViewPlaceholder: UILabel!
    public func configure(text: String?) { //sets everything in the cell up
        descriptionBox.delegate = self //important
        descriptionBox.text = text
        descriptionBox.font = UIFont.boldSystemFont(ofSize: 25.0)
        descriptionBox.textColor = UIColor.black
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        //let grayColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)//custom color (pretty light grey)
        descriptionBox.backgroundColor = normalBGColor
        descriptionBox.layer.borderColor = normalBorderColor
        descriptionBox.layer.borderWidth = 2
        descriptionBox.layer.cornerRadius = 10
        descriptionBox.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        
        textViewPlaceholder = UILabel()
        textViewPlaceholder.font = UIFont.boldSystemFont(ofSize: 25.0)
        textViewPlaceholder.textColor = UIColor.lightGray
        textViewPlaceholder.text = "Option: "
        textViewPlaceholder.sizeToFit()
        textViewPlaceholder.isHidden = !descriptionBox.text.isEmpty
        textViewPlaceholder.frame.origin = CGPoint(x: 12, y: (descriptionBox.font?.pointSize)! / 2 - 3)
        descriptionBox.addSubview(textViewPlaceholder)
        
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        clipsToBounds = true //important
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if #available(iOS 10, *) {
//            UIView.animate(withDuration: 1) { self.contentView.layoutIfNeeded() }
//        }
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
    }
    //restricts number of characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 65
    }
    //shifts color of background
    public func fade(backgroundTo bgColor: UIColor) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.descriptionBox.backgroundColor = bgColor
        }, completion: nil)
    }
    public func shakeError() {
        let errorRed = UIColor(red: 244/255, green: 66/255, blue: 66/255, alpha: 0.7)
        fade(backgroundTo: errorRed)
        self.shake()
        fade(backgroundTo: normalBGColor)
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
    let normalBGColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.8)
    let normalTextColor = UIColor.white
    let greyBG = UIColor(red: 215/255.0, green: 215/255.0, blue: 215/255.0, alpha: 0.75)
    let greyText = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)
    public func configure(BGColor: UIColor, TextColor: UIColor) { //sets everything in the cell up
        //addbutton aesthetics
        textLabel?.text = "+ Add an item"
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        textLabel?.textAlignment = .center
        textLabel?.textColor = TextColor
        // add border and color
        selectionStyle = .none
        backgroundColor = BGColor
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
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
    let normalTextColor = UIColor.black
    public func configure(text: String) {
        questionBar.delegate = self
        questionBar.text = text
        questionBar.font = UIFont.boldSystemFont(ofSize: 34.0)
        questionBar.backgroundColor = normalBGColor
        questionBar.layer.borderColor = UIColor.clear.cgColor
        questionBar.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 10)
        questionBar.layer.cornerRadius = 10
        selectionStyle = .none
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        
        textViewPlaceholder = UILabel() //places a UILabel over the question bar to make a placeholder
        textViewPlaceholder.font = UIFont.boldSystemFont(ofSize: 34.0)
        textViewPlaceholder.textColor = UIColor.lightGray
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
    }
    public func fade(backgroundTo bgColor: UIColor) {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .transitionCrossDissolve, animations: {
            self.questionBar.backgroundColor = bgColor
        }, completion: nil)
    }
    public func shakeError() {
        self.shake()
    }
}
