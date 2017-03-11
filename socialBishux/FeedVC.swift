//
//  FeedVC.swift
//  socialBishux
//
//  Created by Bishr Nebras AlAbbadi on 3/11/17.
//  Copyright © 2017 BishrAlAbbadi. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableFeed: UITableView!
    
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableFeed.delegate = self
        tableFeed.dataSource = self
        
        
        DataService.DS.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postData = snap.value as? Dictionary<String, AnyObject> {
                    let key = snap.key
                    let post = Post(postID: key, postData: postData)
                        self.posts.append(post)
                }
                }
            }
            self.tableFeed.reloadData()
        })
    
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? postCell {
            cell.configureCell(postData: post)
            return cell

        } else {
            return postCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    @IBAction func signOutTapped(_ sender: Any) {
      
        do {
            try FIRAuth.auth()?.signOut()
            print("BISHR: Signed out from firebase Successfully! :)")
        } catch {
            print("BISHR: un able to Sign out from firebase :(")
        }
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        if keychainResult == true {
            print("BISHR: Keychain removed !")
            dismiss(animated: true, completion: nil)
        }
        
        
    }
  
}
