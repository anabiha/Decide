//
//  EditProfileViewController.swift
//  Decide
//
//  Created by user151014 on 5/2/19.
//  Copyright © 2019 AyPeDa. All rights reserved.
//
import UIKit
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var profileButton: UIButton!
    
    // var storageRef: FIRSStorageReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
 
    @IBAction func returnProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func chooseProfileImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes =
            UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        print(info)
        profileButton.setImage(chosenImage, for:  .normal)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func updateUsersProfileImage(){
        
    }
    
    
    
    
    
}






