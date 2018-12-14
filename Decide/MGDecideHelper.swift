//
//  MGDecideHelper.swift
//  Decide
//
//  Created by Ayesha Nabiha on 12/14/18.
//  Copyright © 2018 AyPeDa. All rights reserved.
//

import UIKit

class MGDecideHelper: NSObject {
    
    //called when the user has selected a photo from UIImagePickerController
    var completionHandler: ((UIImage) -> Void)?
    
    //takes a reference to a view controller as a reference, MGDecideHelper needs a UIViewController on which it can present other view controllers
    func presentActionSheet(from viewContrller: UIViewController) {
        
        //present the dialog that allows users to choose between their camera and their photo library
        
        //init a new UIAlertController of type action sheet, used to present different types of alerts
        //action sheet is a popup that will displayed at the bottom edge of the screen
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        //check if the current device has a camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //create a a new UIAlertAction, which represents an action on the UIAlertController
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                
                //do nothing yet ..
                
            })
            
            //add the action to the alert controller
            alertController.addAction(capturePhotoAction)
            
            //do the same as above except for the photo library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                    
                    //do nothing yet..
                    
                })
                
                alertController.addAction(uploadAction)
                
            }
            
            //allow the user to close the action sheet with a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            //present the UIAlertController presenting the alert controller for this method to properly present the UIAlertController
            viewContrller.present(alertController, animated: true)
            
        }
        
        
    }
    

}
