//
//  DataService.swift
//  socialBishux
//
//  Created by Bishr Nebras AlAbbadi on 3/11/17.
//  Copyright © 2017 BishrAlAbbadi. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let DB_STORAGE = FIRStorage.storage().reference()

class DataService {
    
    // MARK:- this is how to creat a singleton, accessable globally:
    static let DS = DataService()
    
    // data ref:
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    // Storage references
    private var _REF_POST_IMAGES = DB_STORAGE.child("post-pics")
    
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference{
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func FirebaseDBUser(uid: String, userData: Dictionary<String,String>){
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }

}
