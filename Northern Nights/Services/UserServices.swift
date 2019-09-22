//
//  UserServices.swift
//  Northern Nights
//
//  Created by hosam on 9/18/19.
//  Copyright © 2019 hosam. All rights reserved.
//


import UIKit
import Firebase

class UserServices {
    static let uerServices = UserServices()
    
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
    func getUserInfo(uid:String,completion: @escaping (UserModel)->())  {
        Database.database().reference(withPath: "Users").child(uid).observe(.value) { (snap) in
            if let dict = snap.value as? [String:Any]{
                let user = UserModel(dict: dict)
                completion(user)
                
            }
        }
    }
    
 
    func getNumberOfPhotosFromUser(uid:String,completion: @escaping (Int)->())  {
        var counts = [String]()
        Database.database().reference(withPath: "Posts").child(uid).observe(.childAdded) { (snap) in
              counts.append(snap.key)
            completion(counts.count)
        }
    }
    
    fileprivate func uploadUserImage(uid:String,image: UIImage,completion: @escaping (String?,Error?)->())  {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else{completion(nil,nil);return}
        
        let storageRef =  Storage.storage().reference(withPath: "User-Images").child(uid)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { (meta, err) in
            if let err = err {
                completion(nil,err) ; return
            }
            storageRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(nil,err) ; return
                }
                if let url = url {
                    completion(url.absoluteString,nil)
                }
            })
        }
    }
    
    func uploadUserImage(uid:String,image:UIImage,completion:@escaping (Error?)->())  {
        uploadUserImage(uid: uid, image: image) { (url, err) in
            let imageUrl = url 
            let values:[String:Any] = ["imageUrl":imageUrl]
            
            Database.database().reference(withPath: "Users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    completion(err) ; return
                }
                completion(nil)
            })
        }
        
    }
    
    
}
