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
        tableview.rowHeight = UITableView.automaticDimension
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.isScrollEnabled = false
        return tableview
    }()
    let backButton: CustomButton = {
        let backButton = CustomButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        return backButton
    }()
    var optionsList: [String]?
    var pageType: SettingsOptionsViewController.SettingsPage?
    let vibration = UIImpactFeedbackGenerator(style: Universal.vibrationStyle)
    //safe area insets dont become active until the view appears, so only set constraints when they become active
    override func viewSafeAreaInsetsDidChange() {
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        tableview.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    override func viewDidLoad() {
        view.backgroundColor = Universal.viewBackgroundColor
        view.addSubview(tableview)
        view.addSubview(backButton)

        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.backgroundColor = UIColor.clear
        
        backButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
    }
    
    @objc func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToSettings", sender: AnyClass.self)
    }
    
    @IBAction func unwindToSettingsOptions(_ sender: UIStoryboardSegue) {}
    
    func configure(page: SettingsOptionsViewController.SettingsPage) {
        pageType = page
        switch page {
        case .Account:
            optionsList = ["Change password", "Delete account"]
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let page = pageType {
            switch page {
            case .Account:
                vibration.impactOccurred()
                if indexPath.row == 0 { self.performSegue(withIdentifier: "showChangePassword", sender: self) }
                break
            default:
                print("SettingsOptionsViewController; didSelectRowAt(): default statement for switch executed")
            }
        } else {
            print("SettingsOptionsViewController; didSelectRowAt(): pagetype doesn't exist ")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel!.font = UIFont(name: Universal.lightFont, size: 20)
        cell.textLabel?.textColor = UIColor.black
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if let options = optionsList {
            cell.textLabel!.text = options[indexPath.row]
        } else {
            print("SettingsOptionsViewController; cellForRowAt(): optionsList is nil")
        }
        return cell
    }
}
