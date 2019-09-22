//
//  UserModel.swift
//  Northern Nights
//
//  Created by hosam on 9/18/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Foundation

struct UserModel {
    let email,uid,imageUrl,name:String
    
    init(dict: [String:Any]) {
        self.email = dict["email"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        
    }
}
