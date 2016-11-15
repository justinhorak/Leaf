//
//  DataService.swift
//  Leaf
//
//  Created by Justin  on 11/13/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper


let DB_BASE = FIRDatabase.database().reference()

class DataService{
    
    
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_PRODUCTS = DB_BASE.child("products")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    var REF_DATA: FIRDatabaseReference{
        return _REF_BASE
    
    
    }
    
    var REF_PRODUCTS: FIRDatabaseReference{
        return _REF_PRODUCTS
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        //let uid = KeychainWrapper.stringForKey(KEY_UID)
        //let uid = KeychainWrapper.set(KEY_UID)
        let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }


    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
        
        
        
        
        
    }
    
    
    
    
}
