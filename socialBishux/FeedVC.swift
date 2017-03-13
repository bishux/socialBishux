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

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var tableFeed: UITableView!
    @IBOutlet weak var imgAdd: FancyImgView!
    @IBOutlet weak var captionField: FancyField!
    
    
    
    var posts = [Post]()
    var imgPicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
 
    override func viewDidLoad() {
        super.viewDidLoad()

        tableFeed.delegate = self
        tableFeed.dataSource = self
        
        imgPicker = UIImagePickerController()
        imgPicker.allowsEditing = true
        imgPicker.delegate = self
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgAdd.image = image
            imageSelected = true
        }
        
        imgPicker.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? postCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imgURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return postCell()
        }
    }

    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let post = posts[indexPath.row]
//        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? postCell {
//            cell.configureCell(postData: post)
//            return cell
//
//        } else {
//            return postCell()
//        }
//    }
    
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
    
    @IBAction func addImgTapped(_ sender: Any) {
        print("BISHR: tapped")
        present(imgPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func postBtnTapped(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "", let img = imgAdd.image, imageSelected == true else {
            print("JESS: Caption must be entered")
            return
        }
        
        captionField.isEnabled = false
        imgAdd.isUserInteractionEnabled = false
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.DS.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("JESS: Unable to upload image to Firebasee torage")
                } else {
                    print("JESS: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgURL: url)
                    }
                }
            }
        }
        
        
    }
    
  
    func postToFirebase(imgURL: String) {
               
        
        let post: Dictionary<String, AnyObject> = [
            "text": captionField.text! as AnyObject,
            "imgURL": imgURL as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.DS.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        captionField.isEnabled = true
        imgAdd.isUserInteractionEnabled = true
        imageSelected = false
        imgAdd.image = UIImage(named: "add-image")
        
    }

}
