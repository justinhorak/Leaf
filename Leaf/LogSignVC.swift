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

        
    
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID){
            print("JESS: ID found in keychain")
            performSegue(withIdentifier: "userIsLoggedIn", sender: nil)
        }
    }

    
    @IBAction func logInButtonTapped(_ sender: UITapGestureRecognizer) {
        
        
        performSegue(withIdentifier: "LogInButton", sender: nil)
        
        
        
    }

    @IBAction func createAccountButtonTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "SignUpButton", sender: nil)
    }

 

}
