//
//  Post.swift
//  socialBishux
//
//  Created by Bishr Nebras AlAbbadi on 3/11/17.
//  Copyright © 2017 BishrAlAbbadi. All rights reserved.
//

import UIKit

class Post {
    
    private var _text: String!
    private var _imgURL: String!
    private var _likes: Int!
    private var _postID: String!
    
    var text: String {
        return _text
    }
    var imgURL: String {
        return _imgURL
    }
    var likes: Int {
        return _likes
    }
    var postID: String {
        return _postID
    }
    
    
    init(text: String, imgURL: String, likes: Int){
        
        self._text = text
        self._imgURL = imgURL
        self._likes = likes
    }

    
    init(postID: String, postData: Dictionary<String, AnyObject>){
        self._postID = postID
        
        if let text = postData["text"] as? String {
            self._text = text
        }
        
        if let imgURL = postData["imgURL"] as? String {
            self._imgURL = imgURL
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }

    
   
}

