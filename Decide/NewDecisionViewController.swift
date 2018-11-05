//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
class NewDecisionViewController: UIViewController {
    @IBOutlet weak var decisionField: UITextField!
override func viewDidLoad() {
    super.viewDidLoad()
}

override func viewWillAppear(_ animated: Bool) { //a lifecycle method that is called before a view appears. I guess when animated is false, nothing appears.
    super.viewWillAppear(animated)
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        guard let identifier = segue.identifier else { return }
        
        // 2
        switch identifier {
        case "cancel":
            print("cancel button tapped")
        case "save":
            print("save button tapped")
        default:
            print("unexpected segue identifier")
        }
    }
}
