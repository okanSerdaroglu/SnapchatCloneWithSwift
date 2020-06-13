//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Okan Serdaroğlu on 13.06.2020.
//  Copyright © 2020 Okan Serdaroğlu. All rights reserved.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
        
    }
    
}
