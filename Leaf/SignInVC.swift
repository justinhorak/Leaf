//
//  SignInVC.swift
//  Leaf
//
//  Created by Justin  on 11/11/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase


class SignInVC: UIViewController {
    
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInTapped(_ sender: UIButton) {
        if let emailText = email.text, let passwordText = password.text{
            
            FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText, completion: { (user, error) in
                if error == nil{
                    print("Hello")
                }else{
                    FIRAuth.auth()?.createUser(withEmail: emailText, password: passwordText, completion: { (user, error) in
                        if error != nil{
                            print("jgjdgd")
                        }else{
                            print("Whats up")
                        }
                        
                    })
                }
                
                
                
            })
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
