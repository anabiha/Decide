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
    @IBOutlet weak var addImage: UIButton!
    
    var decisionItemTitle: String = ""
    
    public func configure(text: String?) { //sets everything in the cell up
        
        descriptionBox.delegate = self //important
        descriptionBox.text = text
        descriptionBox.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        descriptionBox.backgroundColor = UIColor.white
        descriptionBox.layer.cornerRadius = 15
        
        addImage.imageView?.contentMode = .scaleAspectFit
        
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.clear.cgColor
        
        layer.borderWidth = 1
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    func textViewDidChange(_ textView: UITextView) {
        let startHeight = textView.frame.size.height
        let fixedWidth = textView.frame.size.width
        let newSize =  textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if (startHeight != newSize.height) {
            UIView.setAnimationsEnabled(false) // Disable animations
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    //restricts number of characters
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 125
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
            self.backgroundColor = bgColor
            self.textLabel?.textColor = textColor
        }, completion: nil)
    }
   
}

