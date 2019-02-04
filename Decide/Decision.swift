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
    
    var decisionItemTitle: String = ""
    
    public func configure(text: String?) { //sets everything in the cell up
        
        descriptionBox.delegate = self //important
        descriptionBox.text = text
        descriptionBox.font = UIFont.boldSystemFont(ofSize: 25.0)
        
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        let grayColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)//custom color (pretty light grey)
        descriptionBox.backgroundColor = grayColor
        descriptionBox.layer.cornerRadius = 10
        descriptionBox.layer.borderColor = UIColor.white.cgColor
        descriptionBox.layer.borderWidth = 3
        descriptionBox.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        clipsToBounds = true //important
    }
    //changes cell height while text is changing
    func textViewDidChange(_ textView: UITextView) {
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
        let grayColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)//custom color (pretty light grey)
        let errorRed = UIColor(red: 244/255, green: 66/255, blue: 66/255, alpha: 0.7)
        fade(backgroundTo: errorRed)
        self.shake()
        fade(backgroundTo: grayColor)
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
    public func configure() { //sets everything in the cell up
        //addbutton aesthetics
        textLabel?.text = "+ Add an item"
        textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        // add border and color
        selectionStyle = .none
        
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    public func fade(backgroundTo bgColor: UIColor, textTo textColor: UIColor) {
        UIView.animate(withDuration: 0.05, delay: 0, options: .transitionCrossDissolve, animations: {
            self.backgroundColor = bgColor
            self.textLabel?.textColor = textColor
        }, completion: nil)
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

