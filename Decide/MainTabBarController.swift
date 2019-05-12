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
       
        guard let tabViewControllers = tabBarController.viewControllers, let fromIndex = tabViewControllers.index(of: selectedViewController!), let toIndex = tabViewControllers.index(of: viewController), fromIndex != toIndex else {
            print("error indexes are the same")
            return false
        }
        
        animateTabSwitch(to: toIndex)
        //switch statement used to change previouslySelectedIndex
        switch viewController.tabBarItem.tag {
        case 0:
            print("Home button pressed")
        case 1: //don't change previously selected if they press newdecision
            print ("Add decision button pressed")
        case 2:
           
            print ("Profile button pressed")
        default:
            print("Unexpected tab bar item pressed")
        }
        return true
    }
    //FUNCTION DOES NOT HANDLE SWITCHING OF SELECTED TAB
    func animateTabSwitch(to index: Int) {
        guard let fromView = self.selectedViewController?.view, let fromIndex = self.viewControllers?.index(of: self.selectedViewController!),
            let toView = self.viewControllers?[index].view else {
                return
        }
        
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        // Position toView off screen (above subview)
        let screenSize = UIScreen.main.bounds.size
        
        var offsetY: CGFloat!
        var offsetX: CGFloat!
        let isVertical = (index == 1 || fromIndex == 1 && index == 0) ? true : false
        if isVertical {
            offsetY = index == 1 ? -screenSize.height : screenSize.height
            offsetX = 0
        } else {
            offsetY = 0
            offsetX = index == 2 ? -screenSize.width : screenSize.width
        }
        toView.center = CGPoint(x: fromView.center.x - offsetX, y: toView.center.y - offsetY)
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        toView.center = CGPoint(x: toView.center.x + offsetX, y: toView.center.y  + offsetY)
                        fromView.center = CGPoint(x: fromView.center.x + offsetX, y: fromView.center.y  + offsetY)
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
//            self.selectedIndex = index
            self.view.isUserInteractionEnabled = true
        })
    }
}

