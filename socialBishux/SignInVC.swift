//
//  ViewController.swift
//  socialBishux
//
//  Created by Bishr Nebras AlAbbadi on 3/10/17.
//  Copyright © 2017 BishrAlAbbadi. All rights reserved.
//

import UIKit
//MARK:- 1. import login kit of facebook and Firebase
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var passwordField: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:- 2. code the button

    @IBAction func fbBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("BISHR: cannot auth with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("BISHR: user cancelled auth with facebook")
            } else {
                print("BISHR: done auth with facebook!")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    //MARK:- 3. code the func

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("BISHR: cannot auth with firebase - \(error)")
            } else {
                print("BISHR: done auth with firebase!")
            }
        })
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("BISHR: done auth EMAIL USER with firebase!")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error == nil {
                            print("BISHR: DONE create EMAIL USER with firebase!")
                        } else {
                            print("BISHR: unable to create EMAIL USER with firebase!")
                        }
                    })
                }
            })
        }
        
    }
    

}

