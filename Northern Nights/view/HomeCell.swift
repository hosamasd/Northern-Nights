//
//  HomeCell.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    let postImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "_fjegpi89au-thomas-shellberg"))
        im.contentMode = .scaleAspectFill
        im.constrainHeight(constant: 180)
        im.clipsToBounds = true
        return im
    }()
    let profileImageView:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "Thomas-Shellberg"))
//        im.contentMode = .scaleAspectFill
        im.constrainWidth(constant: 25)
        im.constrainHeight(constant: 25)
//        im.layer.cornerRadius = 12
//        im.clipsToBounds = true
        return im
    }()
//    let loveLabelText = UILabel(text: "203", font: .systemFont(ofSize: 18), textColor: .white)
    
     lazy var loveButton = createButtons(title: "230", image: #imageLiteral(resourceName: "heart"), selector: #selector(handleLoved), color: UIColor.black, borderColor: UIColor.white.cgColor)
    lazy var profileInfoButton = createButtons(title: "name sas", image: profileImageView.image, selector: #selector(handleProfileInfo), color: UIColor.black, borderColor: UIColor.black.cgColor)
      lazy var downloadButton = createButtons(title: "", image: #imageLiteral(resourceName: "Download").withRenderingMode(.alwaysTemplate), selector: #selector(handleDownload), color: UIColor.black, borderColor: UIColor.black.cgColor)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()  {
        backgroundColor = .black
        loveButton.constrainWidth(constant: 100)
        downloadButton.constrainWidth(constant: 50)
        stack(postImageView,hstack(loveButton,profileInfoButton,downloadButton, spacing: 4,alignment: .center), spacing: 8).withMargins(.init(top: 8, left: 8, bottom: 8, right: -8))
    }
    
   @objc func handleLoved()  {
        print(023)
    }
    
    @objc func handleProfileInfo()  {
        print(023)
    }
    
    @objc func handleDownload()  {
        print(023)
    }
}
