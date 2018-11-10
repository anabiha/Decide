//
//  MainTabBarController.swift
//  Decide
//
//  Created by Daniel Wei on 11/7/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
         delegate = self
        tabBar.unselectedItemTintColor = .black
    }
}
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        switch viewController.tabBarItem.tag {
        case 0:
            print("Home button pressed")
            return true
        case 1:
            print ("Add decision button pressed")
            return true
        case 2:
            print ("Profile button pressed")
            return false
        default: print("Unexpected tab bar item pressed")
        }
    
        return true
    }
}
