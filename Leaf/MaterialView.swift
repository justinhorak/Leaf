//
//  MaterialView.swift
//  Leaf
//
//  Created by Justin  on 11/5/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {
    
    @IBInspectable var materialDesign: Bool {
        
        get {
            
            return materialKey
        }
        
        set {
            
            materialKey = newValue
            
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 8.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
                self.layer.backgroundColor = UIColor(red: 59/255, green: 59/255, blue: 59/255, alpha: 1.0).cgColor
                
                
            } else {
                
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
            
        }
        
    }
    
}
