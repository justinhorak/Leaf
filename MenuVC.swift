//
//  MenuVC.swift
//  Leaf
//
//  Created by Justin  on 11/9/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    @IBAction func homeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
 
    @IBAction func helpButtonPressed(_ sender: UIButton) {
    }

    @IBAction func accountButtonPressed(_ sender: UIButton) {
    }
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.remove(key: KEY_UID)
        print("JESS: ID removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "isSignedOut", sender: nil)
        
    }
}
