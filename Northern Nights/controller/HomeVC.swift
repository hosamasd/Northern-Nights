//
//  HomeVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit

class HomeVC: BaseCollectionVC {
    
    let cellID = "cellID"
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    override func setupCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override func setupNavigations() {
        navigationItem.title = "Northern Nights"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "head").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleProfile))
    }
    
   @objc func handleProfile()  {
    let profile = ProfileVC()
    let nav = UINavigationController(rootViewController: profile)
    
    present(nav, animated: true)
    }
}
