//
//  PostViewController.swift
//  IFCEApp
//
//  Created by William Nicolau Brasil Araújo on 29/04/19.
//  Copyright © 2019 William Nicolau Brasil Araújo. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        func openGallery(_ sender: UIButton) {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary;
                imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let selectedImage = info[.originalImage] as? UIImage
            imagePicked.image = selectedImage
            
            let storageImage = try? NSKeyedArchiver.archivedData(withRootObject: selectedImage, requiringSecureCoding: false)
            
            dismiss(animated: true, completion: nil)
        }
    }
}

