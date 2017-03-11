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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
    @IBAction func signOut(_ sender: Any) {
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
