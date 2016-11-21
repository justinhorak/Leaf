//
//  WelcomPageVC.swift
//  Leaf
//
//  Created by Justin  on 11/15/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase

class WelcomPageVC: UIViewController {

    @IBOutlet weak var helloUserLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        // Do any additional setup after loading the view.
    }

    
    

    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            //Hello
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.helloUserLabel.text = "Hey, \((dictionary["name"] as? String)!)"
                }
                
                }, withCancel: nil)
        }
    }

}
