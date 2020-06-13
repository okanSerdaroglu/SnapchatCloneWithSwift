//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var textViewPassword: UITextField!
    @IBOutlet weak var textViewUserName: UITextField!
    @IBOutlet weak var textViewEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


    @IBAction func SignUpClicked(_ sender: Any) {
        
            if textViewUserName.text != ""
                && textViewPassword.text != ""
                && textViewEmail.text != ""{
                
                Auth.auth().createUser(withEmail: textViewEmail.text!, password: textViewPassword.text!) { (auth, error) in
                    if error != nil {
                       
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                    } else {

                        let fireStore = Firestore.firestore()
                        let userDictionary = ["email":self.textViewEmail.text!,"username": self.textViewEmail.text!]
                        fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                            if error != nil {
                                
                            }
                            
                        }
                        
                        self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    }
                }
                
            } else {
                self.makeAlert(title: "Error", message: "Username/Password/Email ?")
            }
        
    }
    @IBAction func SighInClicked(_ sender: Any) {
        
        if  textViewPassword.text != ""
             && textViewEmail.text != ""{
            
            Auth.auth().signIn(withEmail: textViewEmail.text!, password: textViewPassword.text!) { (result, error) in
                
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username/Password/Email ?")
        }

    }
    
    func makeAlert (title:String, message:String) {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
    
}

