//
//  LoginVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
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
        tx.text = "h@h.com"
        tx.keyboardType = .emailAddress
        tx.constrainHeight(constant: 25)
        tx.textColor = .white
        return tx
    }()
    lazy var passwordTextField:UITextField = {
        let tx = UITextField()
        tx.textColor = .white
        tx.attributedPlaceholder = NSAttributedString(string: "enter your password",
                                                      attributes: [.foregroundColor: UIColor.white])
        tx.isSecureTextEntry = true
        tx.text = "123456"
        tx.constrainHeight(constant: 25)
        return tx
    }()
    let dividersView:[UIView] = {
        let v = [UIView(),UIView(),]
        v.forEach({ (s) in
            s.constrainHeight(constant: 1)
            s.backgroundColor = .gray
        })
        
        return v
    }()
    lazy var loginButton = createButtons(title: "Login", selector: #selector(handleLogin), color: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1), borderColor: #colorLiteral(red: 0.3960784314, green: 0.8078431373, blue: 0.5450980392, alpha: 1).cgColor)
    lazy var forgetPasswordButton = createButtons(title: "Forget Password?", selector: #selector(handleForget), color: UIColor.clear, borderColor: UIColor.clear.cgColor)
    
    //MARK: -user methods
    
    override  func setupViews()  {
        view.backgroundColor = .white
        
        let emailStack = groupedStack(image: #imageLiteral(resourceName: "email") , text: emailTextField)
        let passwordStack = groupedStack(image: #imageLiteral(resourceName: "lock") , text: passwordTextField)
        view.addSubViews(views: mainImageView,emailStack,dividersView[0],passwordStack,dividersView[1],loginButton,forgetPasswordButton)
        
        mainImageView.fillSuperview()
        emailStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 40, left: 16, bottom: 0, right: 16))
        
        dividersView[0].anchor(top: emailStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 8, left: 16, bottom: 0, right: 16))
        passwordStack.anchor(top: dividersView[0].bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        dividersView[1].anchor(top: passwordStack.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 8, left: 16, bottom: 0, right: 16))
        
        
        loginButton.anchor(top: dividersView[1].bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        forgetPasswordButton.anchor(top: loginButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    
    override func setupNavitagionItems() {
        navigationItem.title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    //TODO: -handle methods
    
    @objc fileprivate func handleCancel()  {
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleLogin()  {
        guard let email = emailTextField.text, !email.isEmpty,
            let pass = passwordTextField.text, !pass.isEmpty  else {showErrorFields(message: "all fields should be filled!") ;  return  }
        
        FirebaseServices.shared.loginFirebase(email: email, pass: pass) { [weak self] (err) in
            if let err=err{
                self?.showErrorFields(message: err.localizedDescription) ; return
            }
            self?.goToHomeVC()
            
        }
    }
    
    @objc fileprivate func handleForget()  {
        let reset = ResetPasswordVC()
        navigationController?.pushViewController(reset, animated: true)
    }
}
