//
//  PhotoHelper.swift
//  Decide
//
//  Created by Ayesha Nabiha on 3/13/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//

import UIKit
import Firebase

class PhotoHelper: NSObject {
    
    var completionHandler: ((UIImage) -> Void)?
    
    func presentActionSheet(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        // check if the device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
      
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                
                self.presentImagePickerController(with: .camera, from: viewController)
               
            })
            

            alertController.addAction(capturePhotoAction)
        }
        
        // check if the device has a photo library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
                
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
              
            })
            
            alertController.addAction(uploadAction)
        }
        
   
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
    
        viewController.present(alertController, animated: true)
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
        
        // this object presents a native UI component that will allow the user to take a photo from the camera or choose an existing image from their photo gallery
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true)
        
    }
    
    func uploadImageToFirebase(imageData: Data) {
        
        
        let storageReference = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = storageReference.child("users").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
        
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                
           //     userProfileImageView.image = UIImage(data: imageData)
                
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
            }
        }
        
    }

}

extension PhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
       // guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            
      //      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
      //  }
        
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
        
    }
    
}
