//
//  postCell.swift
//  socialBishux
//
//  Created by Bishr Nebras AlAbbadi on 3/11/17.
//  Copyright © 2017 BishrAlAbbadi. All rights reserved.
//

import UIKit
import Firebase

class postCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.caption.setContentOffset(CGPoint.zero, animated: false)
    }
  
    
    func configureCell(post: Post, img: UIImage? = nil) {
//        self.post = post
        
        self.caption.text = post.text
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imgURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imgURL as NSString)
                        }
                    }
                }
            })
        }
    }
}
