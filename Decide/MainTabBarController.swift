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
        tabBar.isHidden = true
        view.backgroundColor = Universal.viewBackgroundColor
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        guard let tabViewControllers = tabBarController.viewControllers, let fromIndex = tabViewControllers.firstIndex(of: selectedViewController!), let toIndex = tabViewControllers.firstIndex(of: viewController), fromIndex != toIndex else {
            print("error indexes are the same")
            return false
        }
        
        print("WHY IS IT HERE")
        animateTabSwitch(to: toIndex)
      
        return true
    }
    func animateHalf(to index: Int) {
        
        guard let fromView = self.selectedViewController?.view, let fromIndex = self.viewControllers?.firstIndex(of: self.selectedViewController!),
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
            offsetY = index == 1 ? -screenSize.height/3 : screenSize.height/3
            offsetX = 0
        } else {
            offsetY = 0
            offsetX = index == 2 ? -screenSize.width/3 : screenSize.width/3
        }
        toView.center = CGPoint(x: fromView.center.x - offsetX, y: toView.center.y - offsetY)
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            toView.center = CGPoint(x: toView.center.x + offsetX, y: toView.center.y  + offsetY)
            fromView.center = CGPoint(x: fromView.center.x + offsetX, y: fromView.center.y  + offsetY)
            //self.selectedIndex = index //keeping this in the animate tab rather than the completion = smoother animation
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            //fromView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            
        })
    }
    //FUNCTION HANDLES SWITCHING OF SELECTED TAB
    func animateTabSwitch(to index: Int) {
        
        guard let fromView = self.selectedViewController?.view, let fromIndex = self.viewControllers?.firstIndex(of: self.selectedViewController!),
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
            offsetX = index == 2 || fromIndex == 3 && index == 0 ? -screenSize.width : screenSize.width //2 = move right, 3 = move left
        }
        toView.center = CGPoint(x: fromView.center.x - offsetX, y: toView.center.y - offsetY)
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
      
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            toView.center = CGPoint(x: toView.center.x + offsetX, y: toView.center.y  + offsetY)
            fromView.center = CGPoint(x: fromView.center.x + offsetX, y: fromView.center.y  + offsetY)
            self.selectedIndex = index
            if index == 3 {
                let nc = self.viewControllers![3] as! UINavigationController
                let vc = nc.viewControllers[0] as! SettingsViewController
                vc.animateIn()
            }
           //keeping this in the animate tab rather than the completion = smoother animation
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            print("went to view: \(index)")
            fromView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        })
    }
}

