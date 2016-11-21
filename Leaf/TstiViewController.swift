//
//  TstiViewController.swift
//  Leaf
//
//  Created by Justin  on 11/16/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase

class TstiViewController: UIViewController {
    
    var product: Product!
    
    @IBOutlet weak var marginLbl: UILabel!
    var productAutoId: String!
    
    var margin = 0.0
    var budget  = 0.0
    var nextDayBudget = 0.0
    var testVariable = 0.0
    var todaysSales  = 0
    let uid = FIRAuth.auth()?.currentUser?.uid
    
   

    @IBOutlet weak var titleLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()

    }
    
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        testFunction()
    }
 
    
    func checkIfUserIsLoggedIn() {
         let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                //self.titleLbl.text = "\((dictionary["name"] as? String)!)"
                
                //productReference.child("title").setValue("ILikeDick")
            
                
                if let marginTitle = dictionary["margin"] as? Double, let budgetTitle = dictionary["budget"] as? Double{
                    //productReference.setValue(10)
                    self.budget = budgetTitle
                    self.margin = marginTitle
                    self.marginLbl.text = "\(self.margin)"
                    
                    //self.margin = 100.0
                    
                
                    self.calculateScaling(budget1: self.budget, margin1: self.margin, sales1: 1)
                    self.calculateScaling(budget1: self.budget, margin1: self.margin, sales1: 1)
                    self.calculateScaling(budget1: self.budget, margin1: self.margin, sales1: 3)
                    self.calculateScaling(budget1: self.budget, margin1: self.margin, sales1: 5)
                    
                }
                
                
                
                
            }
            
            }, withCancel: nil)

    }
    
    
    

    
    func todaySalesIncrementor(num: Int){
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let _todaysSales = dictionary["todaysSales"] as? Int{
                    
                    self.todaysSales = _todaysSales
                    self.todaysSales += num
                    productReference.child("todaysSales").setValue(self.todaysSales)
                }
            }
            }, withCancel: nil)
    }
    
    
    func calculateScaling(budget1: Double, margin1: Double, sales1: Double){
        //var nextDayBudget = 0.0
        
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        switch budget1 {
        case 0 ... 9:
            if sales1 == 0{
                nextDayBudget = budget1
                testVariable = 10.0
                print(1)
            }else if 1 ... 2 ~= sales1 {
                nextDayBudget = margin1
                print(2)
                //print(nextDayBudget)
            }else if 3 ... 4 ~= sales1 {
                nextDayBudget = margin1 + 10
                //productReference.child("budget").setValue(nextDayBudget)
                print(3)
                print(nextDayBudget)
            }else{
                nextDayBudget = margin1 + 15
                print(nextDayBudget)
            }
            
            
        default:
            print("Nothing")
            print(margin1)
            print(budget1)
            
        }
        
        
        
        
    }
    
    
    @IBAction func testSale(_ sender: UIButton) {
        //ddSale()
    }
    func testFunction(){
        print("This is a test to see if margin is working print margin: \(testVariable)")
         print("BUDGET: \(budget)")
         print("MARGIN: \(margin)")
        
        
        
    }

    
    
}
