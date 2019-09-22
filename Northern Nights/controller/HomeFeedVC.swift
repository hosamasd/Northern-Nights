//
//  HomeVC.swift
//  Northern Nights
//
//  Created by hosam on 9/17/19.
//  Copyright © 2019 hosam. All rights reserved.
//

import UIKit
import ImagePicker

class HomeFeedVC: BaseCollectionVC {
    
    let cellID = "cellID"
    var postsArray = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
        print(UserServices.uerServices.currentUserId)
    }
    
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! HomeCell
        let post = postsArray[indexPath.item]
        
        cell.post = post
        cell.delgate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    func fetchPosts ()  {
        postsArray.removeAll()
//        PostssServices.postssServices.fetchPostsFromDatabase(fromId: UserServices.uerServices.currentUserId)
        PostssServices.postssServices.fetchPostsFromDatabase(fromId: UserServices.uerServices.currentUserId) { (post) in
            self.sortArray(post: post)
        }
    }
    
    func sortArray(post:PostModel)  {
        postsArray.append(post)
        postsArray = postsArray.sorted(by: {$0.timestamp > $1.timestamp})
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func setupCollection() {
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    
    override func setupNavigations() {
        navigationItem.title = "Northern Nights"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "head").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(handleProfile))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleTakePicture))
    }
    
   @objc func handleTakePicture()  {
    let imagePicker = ImagePickerController()
    imagePicker.delegate = self
    imagePicker.imageLimit = 1
    present(imagePicker, animated: true)
    }
    
   @objc func handleProfile()  {
    let profile = ProfileVC(uid: UserServices.uerServices.currentUserId)
    let nav = UINavigationController(rootViewController: profile)
    
    present(nav, animated: true)
    }
}

extension HomeFeedVC:ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        // Get the first images
        guard let image = images.first else {
            dismiss(animated: true, completion: nil)
            
            return
        }
        PostssServices.postssServices.sendMessagesToFirebase(image: image, fromId: UserServices.uerServices.currentUserId) {[weak self] (err) in
            if let err = err{
                self?.createAlert(title: "Error", message: err.localizedDescription);return
            }
            self?.dismiss(animated: true)
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true)
    }
    
    
}

extension HomeFeedVC:HomeCellProtocol {
    
    func updateVotes(post: PostModel) {
        PostssServices.postssServices.updateVotesFromFirebase(fromId: post.fromId, auto: post.childAuto, number: post.votes + 1, completion: {[weak self] (err) in
            self?.fetchPosts()
        })
    }
}
