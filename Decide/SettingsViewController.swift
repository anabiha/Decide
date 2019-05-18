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
    var container: UIView! //container that holds all options
    var logo: UILabel!
    var preferences: UILabel!
    var account: UILabel!
    var homeTab: UIView! //the tab that acts as a slice of the home view
    let homeTabWidth: CGFloat = 80 //the width of the home tab
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.clipsToBounds = true
        container = UIView()
        logo = UILabel()
        preferences = UILabel()
        account = UILabel()
        homeTab = UIView()
        
        container.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        preferences.translatesAutoresizingMaskIntoConstraints = false
        account.translatesAutoresizingMaskIntoConstraints = false
        homeTab.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(container)
        view.addSubview(homeTab)
        container.addSubview(logo)
        container.addSubview(preferences)
        container.addSubview(account)

        let containerWidth = UIScreen.main.bounds.width - homeTabWidth
        let center = (UIScreen.main.bounds.width - homeTabWidth)/2 //the center of the region between tab and leading anchor
        container.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        container.widthAnchor.constraint(equalToConstant: containerWidth).isActive = true
        container.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: center).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
        logo.topAnchor.constraint(equalTo: container.topAnchor, constant: 150).isActive = true
        logo.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        preferences.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10).isActive = true
        preferences.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        account.topAnchor.constraint(equalTo: preferences.bottomAnchor, constant: 10).isActive = true
        account.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        homeTab.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeTab.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        homeTab.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeTab.widthAnchor.constraint(equalToConstant: homeTabWidth).isActive = true
        
        view.backgroundColor = Universal.blue
        
        logo.text = "Decide"
        logo.font = UIFont(name: Universal.heavyFont, size: 30)
        logo.textColor = UIColor.white
        
        preferences.text = "Preferences"
        preferences.font = UIFont(name: Universal.lightFont, size: 20)
        preferences.textColor = UIColor.white
        
        account.text = "Account"
        account.font = UIFont(name: Universal.lightFont, size: 20)
        account.textColor = UIColor.white
        
        homeTab.backgroundColor = Universal.viewBackgroundColor
        homeTab.layer.cornerRadius = Universal.cornerRadius
        homeTab.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        container.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        let offset = UIScreen.main.bounds.width/2
        self.container.center = CGPoint(x: self.container.center.x - offset, y: self.container.center.y)
        UIView.animate(withDuration: 0.35, delay: 0.05, options: .curveEaseOut, animations: {
            self.container.alpha = 1
            self.container.center = CGPoint(x: self.container.center.x + offset, y: self.container.center.y)
        })
    }
}
