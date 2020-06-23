//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import UIKit

class SnapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    var selectedSnap : Snap?
    var selectedTime : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let time = selectedTime{
            timeLabel.text = "Time Left: \(selectedTime)"
        }
    }
    
    
    
    
    
}
