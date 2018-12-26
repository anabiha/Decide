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
class DecisionItem: UITableViewCell {
 
    @IBOutlet weak var descriptionBox: UITextField!
    let label: String = "TEST"
    public func configure(text: String?, placeholder: String) {
//        descriptionBox?.text = text
//        descriptionBox?.placeholder = placeholder
//       descriptionBox?.accessibilityValue = text
//        descriptionBox?.accessibilityLabel = placeholder
    }
    //some iboutlet textview which will be the description
    //we have to implement this class w a configure function??
}

