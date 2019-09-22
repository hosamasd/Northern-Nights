//
//  ResetPasswordVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseVC {
    
    let mainImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "_fjegpi89au-thomas-shellberg"))
        im.contentMode = .scaleAspectFill
        im.clipsToBounds = true
        return im
    }()
    
    let image:UIImageView = {
        let image =  UIImageView(backgroundColor: .gray)
        image.constrainWidth(constant: 25)
        image.constrainHeight(constant: 25)
        return image
    }()
    
    lazy var emailTextField:UITextField = {
        let tx = UITextField()
        tx.attributedPlaceholder = NSAttributedString(string: "enter your email",
                                                      attributes: [.foregroundColor: UIColor.white])
        tx.constrainHeight(constant: 25)
         tx.keyboardType = .emailAddress
        tx.textColor = .white
        return tx
    }()
    let dividersView:UIView = {
        let v = UIView(backgroundColor: .gray)
    v.constrainHeight(constant: 1)
        
        return v
    }()
    lazy var resetButton = createButtons(title: "Reset My Password", selector: #selector(handleReset), color: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1), borderColor: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1).cgColor)
    override func setupViews()  {
        view.backgroundColor = .white
        
        
        let emailStack = groupedStack(image: #imageLiteral(resourceName: "email") , text: emailTextField)
        view.addSubViews(views: mainImageView,emailStack,dividersView,resetButton)
        
        mainImageView.fillSuperview()
        emailStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 40, left: 16, bottom: 0, right: 16))
        
        dividersView.anchor(top: emailStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 8, left: 16, bottom: 0, right: 16))
       
        
        
        resetButton.anchor(top: dividersView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 24, left: 16, bottom: 0, right: 16))
    }
    
    override func setupNavitagionItems() {
        navigationItem.title = "Reset Password"
    }
    
    
    @objc  func handleReset()  {
        guard let email = emailTextField.text, !email.isEmpty else {showErrorFields(message: "email field should be filled!") ;  return  }
        
        FirebaseServices.shared.resetPassword(email: email) { [weak self] (err) in
            if let err=err{
                self?.showErrorFields(message: err.localizedDescription) ; return
            }
            self?.createAlert(title: "Successfual", message: "we sent an message to your email \n please check it")
        }
    }
    
    
}
