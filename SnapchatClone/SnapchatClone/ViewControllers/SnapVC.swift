//
//  SnapViewController.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 12.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import UIKit
import ImageSlideshow

class SnapVC: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    var selectedSnap : Snap?
    var selectedTime : Int?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let time = selectedTime{
            timeLabel.text = "Time Left: \(selectedTime)"
        }
        
        if let snap = selectedSnap {
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
            
            
        }
        
    }
    
    
    
    
    
}
