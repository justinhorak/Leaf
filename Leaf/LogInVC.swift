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
    
    
    @IBOutlet weak var logInLbl: UILabel!
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
    
    
    @IBAction func emailEditingDidBegin(_ sender: UITextField) {
        moveButton()
    }
    
    @IBAction func passwordEditingBegun(_ sender: UITextField) {
        moveButton()
    }
    
    
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        print("Hello")
        if self.emailTextField.text == ""
        {
            let fail = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let failView = SCLAlertView(appearance: fail)
            
            failView.addButton("Ok"){ () -> Void  in
                
                self.view.endEditing(true)
                
            }
            
            failView.showError("Email Needed!", subTitle: "Enter your email into the text field to reset your password.")
        }
        else
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil
                {
                    title = "Oops!"
                    message = (error?.localizedDescription)!
                }
                else
                {
                    let success = SCLAlertView.SCLAppearance(
                        showCloseButton: false
                    )
                    let successView = SCLAlertView(appearance: success)
                    
                    successView.addButton("Ok"){ () -> Void  in
                        
                        self.view.endEditing(true)
                        
                    }
                    
                    successView.showSuccess("Success", subTitle: "Password reset email sent.")
                }
                
            })
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func moveButton(){
        var duration: TimeInterval = 0.75
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.logInButton.frame = CGRect(
                x: self.logInButton.frame.origin.x,
                y: self.logInButton.frame.origin.y - 200,
                width: self.logInButton.frame.size.width,
                height: self.logInButton.frame.size.height)
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
                    
                    
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .errorCodeWrongPassword:
                            self.logInLbl.text = "Oops, wrong password."
                            self.logInLbl.adjustsFontSizeToFitWidth = true
                        case .errorCodeUserNotFound:
                            self.logInLbl.text = "Can't find that user."
                            self.logInLbl.adjustsFontSizeToFitWidth = true
                        default:
                            print("Create User Error: \(error)")
                        }
                    }
                    
                    
                    
                    print("Email or Password Not Found")
                    //Need to add Lable
                }
                
                
            })
            
        }
    }
    
    
    func setLogInButtonColor(){
        if passwordTextField.text == ""{
            logInButton.isUserInteractionEnabled = false
            logInButton.isHidden = true
            //moveButton()
        }else{
            logInButton.isHidden = false
            logInButton.isUserInteractionEnabled = true
            
            
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.defaultKeychainWrapper.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "LogIn", sender: nil)
    }
    
    
    
    
    
    
}
