//
//  HomeCell.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import SDWebImage

protocol HomeCellProtocol {
    func updateVotes(post:PostModel)
}

class HomeCell: UICollectionViewCell {
    
    var delgate:HomeCellProtocol?
    
    var post:PostModel!{
        didSet{
            let urlSring = post.imageUrl
            guard let url = URL(string: urlSring) else { return  }
            postImageView.sd_setImage(with: url)
            loveButton.setTitle(String(post.votes ?? 0), for: .normal)
            
            UserServices.uerServices.getUserInfo(uid: post.fromId) { (user) in
                self.profileInfoButton.setTitle(user.name, for: .normal)
                let urlSring = user.imageUrl
                guard let url = URL(string: urlSring) else { return  }
                self.profileImageView.sd_setImage(with: url)
            }
            
        }
    }
    
    
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
    var loveButtonClousure: ((PostModel)->())?
    
//    let loveLabelText = UILabel(text: "203", font: .systemFont(ofSize: 18), textColor: .white)
    
     lazy var loveButton = createButtons(title: "", image: #imageLiteral(resourceName: "heart"), selector: #selector(handleLoved), color: UIColor.black, borderColor: UIColor.white.cgColor)
    lazy var profileInfoButton = createButtons(title: "", image: profileImageView.image, selector: #selector(handleProfileInfo), color: UIColor.black, borderColor: UIColor.black.cgColor)
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
    delgate?.updateVotes(post:post)
    }
    
    @objc func handleProfileInfo()  {
        print(023)
    }
    
    @objc func handleDownload()  {
        print(023)
    }
}
