//
//  ViewController.swift
//  Northern Nights
//
//  Created by hosam on 9/15/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class WelcomeVC: BaseVC {
    
    let mainImageView:UIImageView = {
       let im = UIImageView(image: #imageLiteral(resourceName: "_fjegpi89au-thomas-shellberg"))
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    let mainTextLabel = UILabel(text: "Welcome to Northern Lights.", font: .systemFont(ofSize: 36), textColor: .white, numberOfLines: 2)
    lazy var signWithEmail = createButtons(title: "SIGN IN WITH EMAIL", image: #imageLiteral(resourceName: "email"), selector: #selector(handleSignEmail), color: UIColor.clear, borderColor: UIColor.white.cgColor)
    lazy var signWithFacebook = createButtons(title: "SIGN IN WITH Facebook", image: #imageLiteral(resourceName: "facebook"), selector: #selector(handleSignFacebook), color: #colorLiteral(red: 0.3254901961, green: 0.431372549, blue: 0.6470588235, alpha: 1), borderColor: #colorLiteral(red: 0.3254901961, green: 0.431372549, blue: 0.6470588235, alpha: 1).cgColor)
    lazy var signWithGoogle = createButtons(title: "SIGN IN WITH Google", image: #imageLiteral(resourceName: "google"), selector: #selector(handleSignGoogle), color: #colorLiteral(red: 0.8117647059, green: 0.3960784314, blue: 0.3019607843, alpha: 1), borderColor: #colorLiteral(red: 0.8117647059, green: 0.3960784314, blue: 0.3019607843, alpha: 1).cgColor)
    lazy var createAccount = createButtons(title: "Create An Account", selector: #selector(handleCreateAccount), color: UIColor.black, borderColor: UIColor.white.cgColor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
   
    override func setupViews()  {
        let groupButtons = view.verticalStackView(arragedSubViews: signWithEmail,signWithFacebook,signWithGoogle, spacing: 10, distribution: .fillEqually, axis: .vertical)
        groupButtons.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubViews(views: mainImageView,mainTextLabel,groupButtons,createAccount)
        
        mainImageView.fillSuperview()
        mainTextLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 20, left: 16, bottom: 0, right: 16))
        groupButtons.anchor(top:nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        groupButtons.centerInSuperview()
        createAccount.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 20, right: 16))
    }
    
//    func goToHomeVC()  {
//        let layout = UICollectionViewFlowLayout()
//        let home = HomeFeedVC(collectionViewLayout: layout)
//        let nav = UINavigationController(rootViewController: home)
//        present(nav, animated: true)
//    }
    
    
   @objc func handleSignEmail()  {
    let login = LoginVC()
    let nav = UINavigationController(rootViewController: login)
    present(nav, animated: true)
    }
    
    @objc func handleSignGoogle()  {
       GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func handleSignFacebook()  {
        
        FirebaseServices.shared.loginUsingFacebook(vc: self) {[weak self] (err) in
            if let err = err {
                self?.createAlert(title: "Error", message: err.localizedDescription);return
        }
            self?.goToHomeVC()
//        let fbLoginManager = LoginManager()
//        fbLoginManager.logIn(permissions: ["email","public_profile"], from: self) { (res, err) in
//            if let err = err {
//                print(err.localizedDescription);return
//            }
//            guard let token = AccessToken.current else {print("failed to get token"); return}
//
//            let credintal = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        
            // Perform login by calling Firebase APIs
//            Auth.auth().signIn(with: credintal, completion: { (user, error) in
//                if let error = error {
//                    print("Login error: \(error.localizedDescription)")
//                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(okayAction)
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    return
//                }
//                
//                // Present the main view
//                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
//                    UIApplication.shared.keyWindow?.rootViewController = viewController
//                    self.dismiss(animated: true, completion: nil)
//                }
//                
//            })
        }
    }
    
    @objc func handleCreateAccount()  {
        let signup = SignUpVC()
        let nav = UINavigationController(rootViewController: signup)
        present(nav, animated: true)
    }
}

extension WelcomeVC:GIDSignInDelegate,GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) {[weak self] (res, err) in
            if let err = err{
              self?.createAlert(title: "Login Error", message: err.localizedDescription);return
            }
        }
        self.goToHomeVC()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
