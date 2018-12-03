//
//  MainTabBarController.swift
//  Decide
//
//  Created by Daniel Wei on 11/7/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController {
    
    var previouslySelectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
         delegate = self
        tabBar.unselectedItemTintColor = .black
    }
   
    
    //returns to the previous view if user presses cancel button
//    @IBAction func cancel(_ sender: Any) { //it's okay if IBAction is not connected
//        if let index = previouslySelectedIndex {
//            self.selectedIndex = index
//        }
//    }
    
}
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if (previouslySelectedIndex == nil) {
            previouslySelectedIndex = tabBarController.selectedIndex
        }
        switch viewController.tabBarItem.tag {
        case 0:
            print("Home button pressed")
            previouslySelectedIndex = tabBarController.selectedIndex //set the previously selected view so we can revert back to it if needed (ex. if cancel button is pressed)
            print ("Previously selected index is now: \(previouslySelectedIndex!)")
            return true
        case 1:
            print ("Add decision button pressed")
            return true
        case 2:
            print ("Profile button pressed")
            previouslySelectedIndex = tabBarController.selectedIndex //set the previously selected view so we can revert back to it if needed (ex. if cancel button is pressed)
            print ("Previously selected index is now: \(previouslySelectedIndex!)")
            return true
        default:
            print("Unexpected tab bar item pressed")
            return false
        }
    }
}

