//
//  Extensions.swift
//  Decide
//
//  Created by Daniel Wei on 5/6/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import Foundation
import UIKit
import Firebase
extension UIViewController {
    func rephrase(error: NSError) -> String {
        switch (error.code) {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Please enter a valid email."
        case AuthErrorCode.userNotFound.rawValue:
            return "Invalid username or password. Please try again."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Invalid username or password. Please try again."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "User account already exists."
        default:
            return error.localizedDescription
        }
    }
}
//this is how our cell accesses its own tableview
extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }
            return table as? UITableView
        }
    }
}
extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
extension UIView {
    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x,
                               y: self.bounds.size.height * anchorPoint.y)
        
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x,
                               y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
    //allows shaking of cells
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.08
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 12, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 12, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
}
