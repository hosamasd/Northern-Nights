//
//  PostMoedl.swift
//  Northern Nights
//
//  Created by hosam on 9/18/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import Foundation

struct PostModel {
    
    let fromId,postImageUrl,childAuto:String
    let timestamp:Double
     let votes: Int
    
    init(dict:[String:Any]) {
        self.timestamp = dict["timestamp"] as? Double ?? 0.0
        self.fromId = dict["fromId"] as? String ?? ""
        
        self.votes = dict["votes"] as? Int ?? 0
        self.postImageUrl = dict["postImageUrl"] as? String ?? ""
        self.childAuto = dict["childAuto"] as? String ?? ""
    }
}
