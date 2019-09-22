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
    
    //     func uploadImage(uid:String,image: UIImage,completion: @escaping ([String:Any]?,Error?)->())  {
    //    // Generate a unique ID for the post and prepare the post database reference
    //    let postDatabaseRef = POST_DB_REF.childByAutoId()
    //
    //    // Use the unique key as the image name and prepare the storage reference
    //    let imageStorageRef = PHOTO_STORAGE_REF.child("\(postDatabaseRef.key).jpg")
    //
    //    // Resize the image
    //    let scaledImage = image.scale(newWidth: 640.0)
    //
    //    guard let imageData = image.jpegData(compressionQuality: 0.9) else {
    //    return
    //    }
    //
    //    // Create the file metadata
    //    let metadata = StorageMetadata()
    //    metadata.contentType = "image/jpg"
    //
    //    // Prepare the upload task
    //    let uploadTask = imageStorageRef.putData(imageData, metadata: metadata)
    //
    //    // Observe the upload status
    //    uploadTask.observe(.success) { (snapshot) in
    //
    //    guard let displayName = Auth.auth().currentUser?.displayName else {
    //    return
    //    }
    //
    //    // Add a reference in the database
    //    if let imageFileURL = snapshot.metadata?.downloadURL()?.absoluteString {
    //    let timestamp = Int(NSDate().timeIntervalSince1970 * 1000)
    //
    //    let post: [String : Any] = [Post.PostInfoKey.imageFileURL : imageFileURL,
    //    Post.PostInfoKey.votes : Int(0),
    //    Post.PostInfoKey.user : displayName,
    //    Post.PostInfoKey.timestamp : timestamp
    //    ]
    //
    //    postDatabaseRef.setValue(post)
    //    }
    //
    //    completionHandler()
    //    }
    //
    //    uploadTask.observe(.progress) { (snapshot) in
    //
    //    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
    //    print("Uploading... \(percentComplete)% complete")
    //    }
    //
    //    uploadTask.observe(.failure) { (snapshot) in
    //
    //    if let error = snapshot.error {
    //    print(error.localizedDescription)
    //    }
    //    }
    //}
    
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
                        
                        let values: [String:Any] = ["imageUrl":url.absoluteString,
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
    
    
    
    //    func fetchPostsFromDatabase(fromId:String)  {
    //
    //        Database.database().reference(withPath: "Posts").observe(.childAdded) { (snapshot) in
    //            let key = snapshot.key
    //
    ////            Database.database().reference(withPath: "Posts").child(key).observe(.childAdded, with: { (snap) in
    ////                if let dict = snap.value as? [String:Any]{
    ////                    let message = PostModel(dict: dict)
    ////                    completion(message)
    ////
    ////                }
    ////            })
    //        }
    //
    //    }
    
    
    
    
    
    //    func fetchAllMessagesFromDatabase(fromId:String,completion: @escaping (String,MessageModel)->())  {
    //
    //        Database.database().reference(withPath: "User-Messages").child(fromId).observe(.childAdded) { (snapshot) in
    //            let key = snapshot.key
    //            Database.database().reference(withPath: "User-Messages").child(fromId).child(key).observe(.childAdded) { (snap) in
    //                let keys = snap.key
    //                Database.database().reference(withPath: "Inbox").child(keys).observe(.value, with: { (ss) in
    //                    if let dict = ss.value as? [String:Any]{
    //                        let messages = MessageModel(dict: dict)
    //
    //                        completion(key,messages)
    //                    }
    //                })
    //
    //
    //            }
    //
    //
    //        }
    //    }
    //
    //    fileprivate func getGenericData(uid:String,completion: @escaping (UserModel)->())  {
    //        Database.database().reference(withPath: "Users").child(uid).observe(.value) { (snapshot) in
    //            if let dict = snapshot.value as? [String:Any]{
    //                let user = UserModel(dict: dict)
    //                completion(user)
    //            }
    //        }
    //    }
    //
    //    func getUserInfo(uid:String,completion: @escaping (UserModel)->())  {
    //        getGenericData(uid: uid, completion: completion)
    //    }
    //
    
    
    
}
