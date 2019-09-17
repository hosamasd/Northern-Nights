//
//  ExtensionsVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createButtons(title: String,image:UIImage? = UIImage(),selector: Selector,color:UIColor,borderColor:CGColor) -> UIButton {
        let bt = UIButton()
        bt.setTitle(title, for: .normal)
        bt.setImage(image, for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
        bt.imageEdgeInsets = .init(top: 0, left: -30, bottom: 0, right: 0)
        bt.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        bt.addTarget(self, action: selector, for: .touchUpInside)
        bt.layer.cornerRadius = 24
        bt.backgroundColor = color
        bt.titleLabel?.textColor = .white
        bt.constrainHeight(constant: 50)
        bt.layer.borderWidth = 2
        bt.layer.borderColor = borderColor
        return bt
    }
    
    func groupedStack(image:UIImage,text:UITextField) -> UIStackView {
        
        let image = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        image.constrainWidth(constant: 25)
        image.constrainHeight(constant: 25)
        
        
        let sub = UIStackView(arrangedSubviews: [image,text])
        sub.axis = .horizontal
        sub.spacing = 8
        sub.distribution = .fillProportionally
        
        return sub
    }
}

extension UICollectionViewCell {
    func createButtons(title: String,image:UIImage? = UIImage(),selector: Selector,color:UIColor,borderColor:CGColor) -> UIButton {
        let bt = UIButton()
        bt.setTitle(title, for: .normal)
        bt.setImage(image, for: .normal)
        bt.imageView?.contentMode = .scaleAspectFit
       
        bt.imageView?.layer.cornerRadius = 24
         bt.imageView?.clipsToBounds = true
        bt.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        bt.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        bt.addTarget(self, action: selector, for: .touchUpInside)
        bt.layer.cornerRadius = 8
//        bt.backgroundColor = color
        bt.titleLabel?.textColor = .white
        bt.constrainHeight(constant: 40)
        bt.layer.borderWidth = 2
        bt.layer.borderColor = borderColor
        return bt
    }
}
