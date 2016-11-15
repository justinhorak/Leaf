//
//  SignInVC.swift
//  Leaf
//
//  Created by Justin  on 11/11/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper 

class SignUpVC: UIViewController {
    
    @IBOutlet weak var name: HoshiTextField!
    @IBOutlet weak var email: HoshiTextField!
    @IBOutlet weak var password: HoshiTextField!
    
    @IBOutlet weak var nameCheckMark: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var infoLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSignUpVC()
        setSignUpButtonColor()
        
       //observeKeyboardNotifications()
        
    }
    
   
    @IBAction func inputCheckOnPasswordTxtField(_ sender: UITextField) {
        //setSignUpButtonColor()
        //updateSignUpVC()
        
    }
    
    
    
    @IBAction func firstNameTextFieldEditing(_ sender: UITextField) {
        updateSignUpVC()
    }
    @IBAction func emailInputCheck(_ sender: UITextField) {
        updateSignUpVC()
    }
    
    @IBAction func emailTapped(_ sender: UITextField) {
         //keyboardShow()
    }
    
  
    
    @IBAction func test(_ sender: UITextField) {
        setSignUpButtonColor()
    }
    

   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func observeKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        
    }
    
    func updateSignUpVC(){
        if name.text == "" {

            infoLable.text = "What's your name?"
            nameCheckMark.isHidden = true
            email.isHidden = true
            password.isHidden = true
        }else if email.text == ""{
            infoLable.text = "And, your email?"
            email.isHidden = false
            nameCheckMark.isHidden = false
        }else{
            password.isHidden = false
            infoLable.text = "And a Password."
        }

    }
    
    
    
    
    func setSignUpButtonColor(){
        if password.text == "" {
            signUpButton.isUserInteractionEnabled = false
            signUpButton.backgroundColor = UIColor(red: 185/255, green: 192/255, blue: 199/255, alpha: 1.0)
        }else{
            signUpButton.isUserInteractionEnabled = true
            signUpButton.backgroundColor = UIColor(red: 0/255, green: 194/255, blue: 148/255, alpha: 1.0)
            
        }
        
        
    }
    
    
    func keyboardShow(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
            {
                self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
        
        
    }
    
    
    @IBAction func signInTapped(_ sender: UIButton) {
        if let emailText = email.text, let passwordText = password.text{
                    FIRAuth.auth()?.createUser(withEmail: emailText, password: passwordText, completion: { (user, error) in
                        if error != nil{
                            if let user = user{
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }

                        }else{
                            
                            print("Email has already been used")
                        }
                        
                    })
                }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        //let keychainResult = KeychainWrapper.setString(id, forKey: KEY_UID)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "SignIn", sender: nil)
    }

   
}
