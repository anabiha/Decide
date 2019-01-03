//
//  MainTabBarController.swift
//  Decide
//
//  Created by Daniel Wei on 11/7/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var previouslySelectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.unselectedItemTintColor = .black
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if (previouslySelectedIndex == nil) {
            previouslySelectedIndex = tabBarController.selectedIndex
        }
        
        //completes the animation. Returns false if user presses the same tab twice (no animation, obviously)
        var complete: Bool
        if (viewController.tabBarItem.tag == 1) {
            complete = animateToTab(toIndex: 1) //initiate slide up animation if new decision is pressed
            //also note that the tab bar is hidden in this view
        } else {
            complete = true
        }
        //switch statement used to change previouslySelectedIndex
        switch viewController.tabBarItem.tag {
        case 0:
            previouslySelectedIndex = viewController.tabBarItem.tag //set the previously selected view so we can revert back to it if needed (ex. if cancel button is pressed)
            print("Home button pressed")
            print ("Previously selected index is now: \(previouslySelectedIndex!)")
        case 1: //don't change previously selected if they press newdecision
            print ("Add decision button pressed")
            print ("Previously selected index is still: \(previouslySelectedIndex!)")
        case 2:
            previouslySelectedIndex = viewController.tabBarItem.tag //set the previously selected view so we can revert back to it if needed (ex. if cancel button is pressed)
            print ("Profile button pressed")
            print ("Previously selected index is now: \(previouslySelectedIndex!)")
        
        default:
            print("Unexpected tab bar item pressed")
        }
        return complete
    }
    
   //slide up animation!!!
    
    
}

