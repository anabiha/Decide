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
    func animateToTab(toIndex: Int)
}
extension MainTabBarController: Animate {
    func animateToTab(toIndex: Int){
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.index(of: selectedVC),
            fromIndex != toIndex else { return }
        
        // Add the toView to the tab bar view
        fromView.superview?.addSubview(toView)
        
        // Position toView off screen (above subview)
        let screenHeight = UIScreen.main.bounds.size.height
        let offset = -screenHeight
        
        toView.center = CGPoint(x: fromView.center.x, y: toView.center.y - offset)
//        print("offset is \(offset)")
//        print("toView is at : \(toView.center.x), \(toView.center.y)")
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
      
    }
}
extension NewDecisionViewController: Animate {
    func animateToTab(toIndex: Int) {
        let tabBar = self.tabBarController!
        
        guard let tabViewControllers = tabBar.viewControllers,
            let selectedVC = tabBar.selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.index(of: selectedVC),
            fromIndex != toIndex else { return }
        
        // Position fromView on screen
        let screenHeight = UIScreen.main.bounds.size.height
        let offset = screenHeight
        fromView.center = CGPoint(x: toView.center.x, y: toView.center.y)
//        print("fromView is at: \(fromView.center.x), \(fromView.center.y)")
//        print("offset is \(offset)")
        
        // Disable interaction during animation
        tabBar.view.isUserInteractionEnabled = false
    
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: .curveEaseIn,
                       animations: {
                        // Slide the views by -offset
                    fromView.center = CGPoint(x: fromView.center.x, y: fromView.center.y + offset)
        }, completion: { finished in
            print("fromView is at: \(fromView.center.x), \(fromView.center.y) after the animation")
            
            //select the next view
            tabBar.selectedIndex = toIndex
            //Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            
            tabBar.view.isUserInteractionEnabled = true
            
            //reset view controller
            let vc = self.storyboard!.instantiateViewController(withIdentifier:"NewDecisionViewController") as! NewDecisionViewController
            let nc = self.tabBarController!.viewControllers?[1] as! UINavigationController
            nc.viewControllers[0] = vc
        })
    }
}
