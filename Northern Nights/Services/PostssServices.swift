//
//  MessagesServices.swift
//  Northern Nights
//
//  Created by hosam on 9/18/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase

class PostssServices {
    
    static let postssServices = PostssServices()
    
    func uploadImage(uid:String,image: UIImage,completion: @escaping ([String:Any]?,Error?)->())  {
        let date = Date().timeIntervalSince1970
        // Resize the image
        let scaledImage = image.scale(newWidth: 640.0)
        if let imageData = scaledImage.jpegData(compressionQuality: 0.9) {
            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            let storageRef =  Storage.storage().reference(withPath: "Posts").child(uid)
            let uploadTask =   storageRef.putData(imageData, metadata: metadata) { (meta, err) in
                if let err = err {
                    completion(nil,err) ; return
                }
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        completion(nil,err) ; return
                    }
                    if let url = url {
                        
                        let values: [String:Any] = ["postImageUrl":url.absoluteString,
                                                    "timestamp":date ,"votes":0,"fromId":uid]
                        
                        completion(values,nil)
                    }
                })
            }
            
            uploadTask.observe(.progress) { (snapshot) in
                
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                print("Uploading... \(percentComplete)% complete")
            }
            
            uploadTask.observe(.failure) { (snapshot) in
                
                if let error = snapshot.error {
                    completion(nil,error);  print(error.localizedDescription)
                }
            }
        }
    }
    
    func sendMessagesToFirebase(image:UIImage,fromId:String,completion: @escaping (Error?)->())  {
        
        uploadImage(uid: fromId, image: image) { (vals, err) in
            if let err = err {
                completion(err);return
            }
            guard var values = vals else {return}
            
            let ref =   Database.database().reference(withPath: "Posts").child(fromId)
            let refAuto = ref.childByAutoId()
            values["childAuto"] = refAuto.key
            refAuto.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    completion(err);return
                }
                completion(nil)
            })
        }
        
    }
    
    func getVoteCount(uid:String,auto:String,completion:@escaping (Int)->())  {
        Database.database().reference(withPath: "Posts").child(uid).child(auto).observe(.value) { (snap) in
            if let dict = snap.value as? [String:Any] {
                let count = dict["votes"] as? Int
                completion(count ?? 0)
            }
        }
    }
    
    func updateVotesFromFirebase(fromId:String,auto:String,number:Int,completion: @escaping (Error?)->())  {
        let vals:[String:Any] = ["votes":number]
        Database.database().reference(withPath: "Posts").child(fromId).child(auto).updateChildValues(vals, withCompletionBlock: { (err, ref) in
            if let err = err {
                completion(err);return
                
            }
            completion(nil)
        })
    }
    
   
    
    
    func fetchPostsFromDatabase(fromId:String,completion: @escaping (PostModel)->())  {
        
        Database.database().reference(withPath: "Posts").observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            Database.database().reference(withPath: "Posts").child(key).observe(.childAdded, with: { (snap) in
                if let dict = snap.value as? [String:Any]{
                    let message = PostModel(dict: dict)
                    completion(message)
                    
                }
            })
        }
    }
    
    
    
    
}
