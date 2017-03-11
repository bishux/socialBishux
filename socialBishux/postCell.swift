//
//  postCell.swift
//  socialBishux
//
//  Created by Bishr Nebras AlAbbadi on 3/11/17.
//  Copyright © 2017 BishrAlAbbadi. All rights reserved.
//

import UIKit

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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    func configureCell(postData: Post) {
        
        caption.text = postData.text
        likesLbl.text = "\(postData.likes)"
      //  postImg.image = UIImage(data: Data(URL(string: postData.imgURL)))
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
