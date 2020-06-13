//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import UIKit

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewUploadedImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(choosePicture))
        imageViewUploadedImage.addGestureRecognizer(gestureRecognizer)

    }
    
    @objc func choosePicture(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker,animated: true,completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewUploadedImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageViewUploadedImage: UIImageView!
    

    @IBAction func button_upload(_ sender: Any) {
    }
}
