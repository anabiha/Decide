//
//  CustomSegue.swift
//  Decide
//
//  Created by Daniel Wei on 5/25/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
/*these classes consist of the cusotm segue and unwind segue that connect settings and settings options view controllers
 They include custom animations
*/
class CustomSegue: UIStoryboardSegue {
    override func perform() {
        let fromView = source.view! as UIView
        let toView = destination.view! as UIView
        
        // Position toView off screen (above subview)
        let screenSize = UIScreen.main.bounds.size
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(toView, aboveSubview: fromView)
        
        let offsetX = -screenSize.width
        toView.center = CGPoint(x: fromView.center.x - offsetX, y: toView.center.y)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            toView.center = CGPoint(x: toView.center.x + offsetX, y: toView.center.y)
            fromView.center = CGPoint(x: fromView.center.x + offsetX, y: fromView.center.y)
            //keeping this in the animate tab rather than the completion = smoother animation
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            self.source.present(self.destination, animated: false, completion: nil)
        })
    }
}
class CustomUnwindSegue: UIStoryboardSegue {
    override func perform() {
        let fromView = source.view! as UIView
        let toView = destination.view! as UIView
        
        // Position toView off screen (above subview)
        let screenSize = UIScreen.main.bounds.size
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(toView, aboveSubview: fromView)
        
        let offsetX = screenSize.width
        toView.center = CGPoint(x: fromView.center.x - offsetX, y: toView.center.y)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            toView.center = CGPoint(x: toView.center.x + offsetX, y: toView.center.y)
            fromView.center = CGPoint(x: fromView.center.x + offsetX, y: fromView.center.y)
            //keeping this in the animate tab rather than the completion = smoother animation
        }, completion: { finished in
            // Remove the old view from the tabbar view.
            self.source.dismiss(animated: false, completion: nil)
        })
    }
}
