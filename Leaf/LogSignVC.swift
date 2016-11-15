//
//  LogSignVC.swift
//  Leaf
//
//  Created by Justin  on 11/13/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LogSignVC: UIViewController {

    
    
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
//            if let user = user {
//                self.performSegue(withIdentifier: "userIsLoggedIn", sender: nil)
//            } else {
//                // No user is signed in.
//                print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
//            }
//        }
        
//        if let user = FIRAuth.auth()?.currentUser{
//            performSegue(withIdentifier: "userIsLoggedIn", sender: nil)
//            print("?????????????????????????????User logged in ")
//        }else{
//            print("User not logged in")
//        }
        
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("JESS: ID found in keychain")
            performSegue(withIdentifier: "userIsLoggedIn", sender: nil)
        }
    }

    
//    func isLoggedIn() -> Bool {
//        
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
//    }

 

}
