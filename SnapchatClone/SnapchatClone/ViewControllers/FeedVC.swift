//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableViewSnapList:UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    var timeLeft : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSnapList.delegate = self
        tableViewSnapList.dataSource = self
        
        getUserInfo()
        getSnapsFromFirebase()
    }
    
    func getSnapsFromFirebase (){
        fireStoreDatabase.collection("Snaps").order(by: "date",descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil{
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error!")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll()
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentID)
                                                .delete { (error) in
                                                    
                                            }
                                        }
                                        
                                        self.timeLeft = 24 - difference
                                        
                                    }
                                    
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                }
                            }
                        }
                    }
                    self.tableViewSnapList.reloadData()
                }
            }
        }
    }
    
    func getUserInfo (){
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo:Auth.auth().currentUser!.email!).getDocuments{(snapshot,error) in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        let snap = snapArray[indexPath.row]
        cell.labelUserName.text = snapArray[indexPath.row].username
        cell.feedImageViewCell.sd_setImage(with: URL(string: snap.imageUrlArray[0]))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            destinationVC.selectedTime = self.timeLeft
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
}
