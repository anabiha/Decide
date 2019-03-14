//
//  Storyboard+Utility.swift
//  Decide
//
//  Created by Ayesha Nabiha on 2/26/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    // CRType is to identify that this enum was created by us (CR stands for CRisp)
    enum CRType: String {
        
        case main
        case login
        
        var filename: String {
            
            return rawValue.capitalized
            
        }
        
    }
    
    // will make use of our enum
    convenience init(type: CRType, bundle: Bundle? = nil) {
        
        self.init(name: type.filename, bundle: bundle)
        
    }
    
    // so whenever we want to access a storyboard, we can say:
    // let loginStoryboard = UIStoryboard(type: .login)
    
    static func initialViewController(for type: CRType) -> UIViewController {
        
        let storyboard = UIStoryboard(type: type)
        
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        
        return initialViewController
        
    }
    
    
}
