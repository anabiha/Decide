//
//  Animate.swift
//  Decide
//
//  Created by Daniel Wei on 1/3/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
protocol Animate {
    func animateToTab(toIndex: Int) -> Bool
   
}
extension MainTabBarController: Animate {
    func animateToTab(toIndex: Int) -> Bool {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return false}
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.index(of: selectedVC),
            fromIndex != toIndex else { return false}
        
        
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        
        // Position toView off screen (above subview)
        let screenHeight = UIScreen.main.bounds.size.height
        let offset = -screenHeight
        
        toView.center = CGPoint(x: fromView.center.x, y: toView.center.y - offset)
        print("offset is \(offset)")
        print("toView is at : \(toView.center.x), \(toView.center.y)")
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        // Slide the views by -offset
                        toView.center = CGPoint(x: toView.center.x, y: toView.center.y  + offset)
                        print("toView is at : \(toView.center.x), \(toView.center.y) after the animation")
        }, completion: { finished in
            // Remove the old view from the tabbar view.
//            fromView.removeFromSuperview() removed, because when returning to page it must remain
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
        
   
        return true
    }
}
extension NewDecisionViewController: Animate {
    func animateToTab(toIndex: Int) -> Bool{
        let tabBar = self.tabBarController!
        
        guard let tabViewControllers = tabBar.viewControllers,
            let selectedVC = tabBar.selectedViewController else { return false}
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.index(of: selectedVC),
            fromIndex != toIndex else { return false}
        
        toView.superview?.addSubview(fromView)
        
        // Position fromView on screen
        let screenHeight = UIScreen.main.bounds.size.height
        let offset = screenHeight
        fromView.center = CGPoint(x: toView.center.x, y: toView.center.y)
        print("fromView is at: \(fromView.center.x), \(fromView.center.y)")
        print("offset is \(offset)")
        
        // Disable interaction during animation
        tabBar.view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: .curveEaseIn,
                       animations: {
                        // Slide the views by -offset
                    fromView.center = CGPoint(x: fromView.center.x, y: fromView.center.y + offset + 200)
        }, completion: { finished in
            print("fromView is at: \(fromView.center.x), \(fromView.center.y) after the animation")
            //             Remove the old view from the tabbar view.
            //fromView.removeFromSuperview()
            tabBar.selectedIndex = toIndex
            tabBar.view.isUserInteractionEnabled = true
        })
      
            return true
    }


}
