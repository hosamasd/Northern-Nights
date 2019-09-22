//
//  FirebaseServices.swift
//  Northern Nights
//
//  Created by hosam on 9/18/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit


class FirebaseServices {
    static let shared = FirebaseServices()
    
    
    
    fileprivate func uploadImage(uid:String,image: UIImage,completion: @escaping (String?,Error?)->())  {
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
    
    func signUpFirebase(email: String,name: String,passowrd: String,completion: @escaping (Error?)->())  {
        Auth.auth().createUser(withEmail: email, password: passowrd) { (user, err) in
            if let err = err {
                completion(err) ;return
            }
            if let useUID=user?.user.uid {
                self.manipulateDataInFirebase( uid: useUID, email: email, name: name, completion: completion)
            }
        }
    }
    
    func manipulateDataInFirebase(uid:String,email: String,name: String,completion: @escaping (Error?)->()) {
       
            var values:[String:Any] = ["email":email, "uid":uid, "name":name]
            
            Database.database().reference(withPath: "Users").child(uid).updateChildValues(values) { (err, ref) in
                if let err = err {
                    completion(err); return
                }
                
                completion(nil)
                
            }
        
    }
    
    func resetPassword(email:String,completion: @escaping (Error?)->()) {
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    func loginUsingGoogle(error:Error,user:GIDGoogleUser,completion: @escaping (Error?)->())  {
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (res, err) in
            if let err = err{
                completion(err);return
            }
        }
    }
    
    func loginUsingFacebook(vc:UIViewController,completion: @escaping (Error?)->())  {
        
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email","public_profile"], from: vc) { (res, err) in
            if let err = err {
                completion(err);return
            }
            guard let token = AccessToken.current else {print("failed to get token"); return}
            
            let credintal = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        
            Auth.auth().signIn(with: credintal) { (res, err) in
            if let err = err{
                completion(err);return
            }
        }
    }
    }
    
    func loginFirebase(email:String,pass:String,completion: @escaping (Error?)->())  {
        Auth.auth().signIn(withEmail: email, password: pass) { (res, err) in
            if let err = err {
                completion(err); return
            }
            completion(nil)
        }
    }
    
    func LogOut(completion: @escaping (Error?)->()) {
         do {
        if let providerData = Auth.auth().currentUser?.providerData {
            let userInfo = providerData[0]
            
            switch userInfo.providerID {
            case "google.com":
                GIDSignIn.sharedInstance()?.signOut()
            default  :
                completion(nil); return
            }
        }
       
            try Auth.auth().signOut()
            completion(nil)
        } catch let err {
            completion(err);return
        }
        
    }
}
