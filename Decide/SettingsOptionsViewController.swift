//
//  SettingsOptionsViewController.swift
//  Decide
//
//  Created by Daniel Wei on 5/22/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit

class SettingsOptionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //enumeration passed into the configure function to determine which page this is
    enum SettingsPage {
        case Account
        case Preferences
        case About
    }
    
    let tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.estimatedRowHeight = 43.5
        tableview.backgroundColor = UIColor.clear
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.isScrollEnabled = false
        tableview.separatorStyle = .none
        return tableview
    }()
    let backButton: CustomButton = {
        let backButton = CustomButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.configure(tuple: button.popupCancel)
        return backButton
    }()
    var optionsList: [String]?
    var pageType: SettingsOptionsViewController.SettingsPage?
    
    override func viewDidLoad() {
        view.backgroundColor = Universal.viewBackgroundColor
        view.addSubview(tableview)
        view.addSubview(backButton)
        
        tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        configure(page: .Account)
    }
    func configure(page: SettingsOptionsViewController.SettingsPage) {
        pageType = page
        switch page {
        case .Account:
            optionsList = ["Reset password", "Delete account"]
            break
        case .Preferences:
            optionsList = ["idk"]
            break
        case .About:
            optionsList = ["idk"]
            break
        default:
            print("SettingsOptionsViewController; configure(): default statement for switch executed")
            optionsList = []
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let options = optionsList {
            return options.count
        } else {
            print("SettingsOptionsViewController; numberOfRowsInSection(): optionsList is nil")
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel!.font = UIFont(name: Universal.lightFont, size: 20)
        if let options = optionsList {
            cell.textLabel!.text = options[indexPath.row]
        } else {
            print("SettingsOptionsViewController; cellForRowAt(): optionsList is nil")
        }
        return cell
    }
}
