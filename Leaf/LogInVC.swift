//
//  LogInVC.swift
//  Leaf
//
//  Created by Justin  on 11/13/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LogInVC: UIViewController {
     //let defaults = UserDefaults.standard
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkPasswordInput(_ sender: UITextField) {
        setLogInButtonColor()
    }
    
    
    
    
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        if let emailText = emailTextField.text, let passwordText = passwordTextField.text{
            
            FIRAuth.auth()?.signIn(withEmail: emailText, password: passwordText, completion: { (user, error) in
                if error == nil{
                    if let user = user{
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                
                }else{
                    print("Email or Password Not Found")
                    //Need to add Lable
                }
                
                
            })
            
        }
    }
     

    func setLogInButtonColor(){
        if passwordTextField.text == ""{
            logInButton.isUserInteractionEnabled = false
            logInButton.backgroundColor = UIColor(red: 185/255, green: 192/255, blue: 199/255, alpha: 1.0)
        }else{
            logInButton.isUserInteractionEnabled = true
            logInButton.backgroundColor = UIColor(red: 0/255, green: 194/255, blue: 148/255, alpha: 1.0)
            
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "LogIn", sender: nil)
    }
    
    
    
    
    
    
}
