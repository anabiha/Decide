//
//  NewDecisionViewController.swift
//  Decide
//
//  Created by Daniel Wei on 11/4/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
class NewDecisionViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var decisionTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var decision = Decision()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //some function that, once tapped, saves the title and all decisions
    
    //function to hide the cells until add decisionitem button is tapped
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // 1
//        guard let identifier = segue.identifier else { return }
//
//        // 2
//        switch identifier {
//        case "cancel":
//            print("cancel button tapped")
//        case "save":
//            print("save button tapped")
//        default:
//            print("unexpected segue identifier")
//        }
//    }
}
