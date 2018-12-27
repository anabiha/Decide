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
        switch viewController.tabBarItem.tag {
        case 0:
            print("Home button pressed")
            previouslySelectedIndex = tabBarController.selectedIndex //set the previously selected view so we can revert back to it if needed (ex. if cancel button is pressed)
            print ("Previously selected index is now: \(previouslySelectedIndex!)")
        case 1:
            print ("Add decision button pressed")
         
        case 2:
            print ("Profile button pressed")
            previouslySelectedIndex = tabBarController.selectedIndex //set the previously selected view so we can revert back to it if needed (ex. if cancel button is pressed)
            print ("Previously selected index is now: \(previouslySelectedIndex!)")
        
        default:
            print("Unexpected tab bar item pressed")
        }
        return animateToTab(tabBarController: tabBarController, to: viewController)
    }
    
    //animates transitions between tab bars
    func animateToTab(tabBarController: UITabBarController, to viewController: UIViewController) -> Bool {
        let fromView = selectedViewController?.view
        let toView = viewController.view
        
        if fromView != toView {
            UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
            return true
        } else {
            return false
        }
        //HAVE TO CHANGE THIS ANIMATION!!!
        
    }
    
}

