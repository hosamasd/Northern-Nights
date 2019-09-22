//
//  ProfileVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileVC: BaseVC {
    
  fileprivate  let uid:String
    init(uid:String) {
        self.uid = uid
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "_fjegpi89au-thomas-shellberg"))
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    
    lazy var profileImageView:UIImageView = {
        let image =  UIImageView(backgroundColor: .gray)
        image.constrainWidth(constant: 150)
        image.constrainHeight(constant: 150)
        image.layer.cornerRadius = 75
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseImage)))
        return image
    }()
    let usernameLabelText = UILabel(text: "hosam", font: .systemFont(ofSize: 24), textColor: .white, textAlignment: .center)
     let userPhotosLabelText = UILabel(text: "0 photos", font: .systemFont(ofSize: 20), textColor: .white, textAlignment: .center)
     lazy var logoutButton = createButtons(title: "Logout", selector: #selector(handleLogout), color: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1), borderColor: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1).cgColor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
     //MARK: -user methods
    
    override func setupViews() {
        view.backgroundColor = .white
        
        view.addSubViews(views: mainImageView,profileImageView,usernameLabelText,userPhotosLabelText,logoutButton)
        
        mainImageView.fillSuperview()
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 40, left: 0, bottom: 0, right: 0))
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
         usernameLabelText.anchor(top: profileImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
         userPhotosLabelText.anchor(top: usernameLabelText.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
         logoutButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 20, right: 16))
    }
    
    override func setupNavitagionItems() {
        navigationItem.title = "My Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
   fileprivate func  loadUserInfo()  {
       
        UserServices.uerServices.getUserInfo(uid: uid) { (user) in
            self.putData(user:user)
        }
    }
    
  fileprivate  func  putData(user:UserModel)  {
        UserServices.uerServices.getNumberOfPhotosFromUser(uid: user.uid) { (count) in
            self.userPhotosLabelText.text = "\(count) Photos"
        }
    usernameLabelText.text = user.name
        let urlSring = user.imageUrl
        guard let url = URL(string: urlSring) else { return  }
        self.profileImageView.sd_setImage(with: url)
    }
    
    //TODO: -handle methods
    
    @objc fileprivate func handleCancel()  {
        dismiss(animated: true)
    }
    
    @objc func handleLogout()  {
        ProgressHUD.show("Logout Confirmed!")
        FirebaseServices.shared.LogOut {[weak self] (err) in
            if let err = err{
                self?.showErrorFields(message: err.localizedDescription)
            }
            ProgressHUD.dismiss()
            self?.present(WelcomeVC(), animated: true)
        }
    }
    
   @objc fileprivate func handleChooseImage()  {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true)
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[.originalImage] as? UIImage {
            profileImageView.image = img
        }
        if let img = info[.editedImage] as? UIImage {
            profileImageView.image = img
        }
       
        UserServices.uerServices.uploadUserImage(uid: uid, image: profileImageView.image ?? UIImage()) { (err) in
            if let err = err {
//                print(err.localizedDescription);return
                    ProgressHUD.showError(err.localizedDescription); return
            }
            self.loadUserInfo()
        }
        
        dismiss(animated: true)
    }
}
