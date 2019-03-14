//
//  PhotoHelper.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit

class PhotoHelper: NSObject {
    
    var completionHandler: ((UIImage) -> Void)?
    
    func presentActionSheet(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        // check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
      
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
               
            })
            

            alertController.addAction(capturePhotoAction)
        }
        
        // check if the device has a photo library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
              
            })
            
            alertController.addAction(uploadAction)
        }
        
   
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
    
        viewController.present(alertController, animated: true)
    }

}
