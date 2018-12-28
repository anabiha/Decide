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
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if (previouslySelectedIndex == 1 && tabBarController.selectedIndex != 1) {
//            print("New Decision was reset upon exit")
//            let nav = self.viewControllers![1] as? UINavigationController
//            nav!.popViewController(animated: false)
//        }
//    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if (previouslySelectedIndex == nil) {
            previouslySelectedIndex = tabBarController.selectedIndex
        }
        
        //completes the animation. Returns false if user presses the same tab twice (no animation, obviously)
        let complete = animateToTab(tabBarController: tabBarController, to: viewController)
        
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

