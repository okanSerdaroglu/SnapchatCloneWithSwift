//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import UIKit
import Firebase

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
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageViewUploadedImage.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (metaData, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            let fireStore = Firestore.firestore()
                            
                            let snapDictionary = ["imageUrl": imageUrl!,"snapOwner": UserSingleton.sharedUserInfo.username,"date":FieldValue.serverTimestamp()] as [String:Any]
                            
                            fireStore.collection("Snaps").addDocument(data: snapDictionary){
                                (error) in
                                
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.tabBarController?.selectedIndex = 0
                                    self.imageViewUploadedImage.image = UIImage(named: "select")
                                }
                            }
                            
                        }
                    }
                    
                }
             }
        }

    }
    
    func makeAlert (title:String, message:String) {
         let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
         let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
         alert.addAction(okButton)
         self.present(alert,animated: true,completion: nil)
         
     }
    
}
