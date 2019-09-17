//
//  ProfileVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {
    
    let mainImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "_fjegpi89au-thomas-shellberg"))
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    
    let profileImageView:UIImageView = {
        let image =  UIImageView(backgroundColor: .gray)
        image.constrainWidth(constant: 150)
        image.constrainHeight(constant: 150)
        image.layer.cornerRadius = 75
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let usernameLabelText = UILabel(text: "hosam", font: .systemFont(ofSize: 24), textColor: .white, textAlignment: .center)
     let userPhotosLabelText = UILabel(text: "303 photos", font: .systemFont(ofSize: 20), textColor: .white, textAlignment: .center)
     lazy var logoutButton = createButtons(title: "Logout", selector: #selector(handleLogout), color: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1), borderColor: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1).cgColor)
    
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
    
    @objc func handleCancel()  {
        dismiss(animated: true)
    }
    
    @objc func handleLogout()  {
        print(012)
    }
}
