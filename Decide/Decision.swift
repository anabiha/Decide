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
        descriptionBox.font = UIFont.boldSystemFont(ofSize: 14.0)
        descriptionBox.accessibilityValue = text
       // descriptionBox.setLeftPaddingPoints(15); //see UITextField extension below
        selectionStyle = .none//disables the "selected" animation when someone clicks on the cell, but still allows for interaction with the descriptionBox
        //setting the colors of the descriptionBox and row
        let grayColor2 = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)//custom color (even lighter gray)
        descriptionBox.backgroundColor = grayColor2
        descriptionBox.layer.cornerRadius = 15
        
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.white.cgColor
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
        // add border and color
        let grayColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)//custom color (pretty light gray)
        backgroundColor = grayColor
        layer.borderColor = grayColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}

