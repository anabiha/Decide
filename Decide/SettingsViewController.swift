//
//  SettingsViewController.swift
//  Decide
//
//  Created by Daniel Wei on 5/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    var companyName: UILabel!
    var account: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Universal.blue
        modalPresentationStyle = .currentContext
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height)
        companyName = UILabel()
        account = UILabel()
        companyName.translatesAutoresizingMaskIntoConstraints = false
        companyName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(companyName)
        view.addSubview(account)
        
        companyName.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        companyName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        account.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 10)
        account.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
    }
}
