//
//  ScalingVC.swift
//  Leaf
//
//  Created by Justin  on 11/18/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import Firebase

class ScalingVC: UIViewController {
    
    var productAutoId: String!
    let formatter = NumberFormatter()
    let percentFormat = NumberFormatter()
    
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var todaysSalesLbl: UILabel!
    @IBOutlet weak var nextDayBudgetLbl: UILabel!
    @IBOutlet weak var projSalesLbl: UILabel!
    @IBOutlet weak var roiLbl: UILabel!
    @IBOutlet weak var cpaLbl: UILabel!
    @IBOutlet weak var starRatingImg: UIImageView!
    @IBOutlet weak var totalSalesLbl: UILabel!
    @IBOutlet weak var totalAdSpendLbl: UILabel!
    //@IBOutlet weak var trendImg: UIImageView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var budgetMarginLbl: UILabel!
    
    
    var margin = 0.0
    var budget  = 0.0
    var nextDayBudget = 0.0
    var todaysSales  = 0
    var roi = 0.0
    var cpa = 0.0
    var grade = "A"
    var projSales = 0.0
    var totalSales = 0.0
    var totalAdSpend = 0.0
    
    
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .currency
        percentFormat.numberStyle = .percent
        bringInData()
    }
    
    @IBAction func endTheDayButtonPressed(_ sender: UITapGestureRecognizer) {
        
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let _todaysSales = dictionary["todaysSales"] as? Int, let _totalAdSpend = dictionary["totalAdSpend"] as? Double, let _budget = dictionary["budget"] as? Double{
                    
                    self.todaysSales = _todaysSales
                    self.totalAdSpend = _totalAdSpend
                    self.budget = _budget
                    
                    
                    
                    self.totalAdSpend += self.budget
                    self.todaysSales = 0
                    productReference.child("totalAdSpend").setValue(self.totalAdSpend)
                    productReference.child("todaysSales").setValue(self.todaysSales)
                    self.todaysSalesLbl.text = "\(self.todaysSales)"
                    self.totalAdSpendLbl.text = self.formatter.string(from: self.totalAdSpend as NSNumber)
                    
                    
                    
                    //                            if self.nextDayBudget > self.budget{
                    //                                self.budgetLbl.text = self.formatter.string(from: self.nextDayBudget as NSNumber)
                    //                            }else{
                    //                                print(self.nextDayBudget)
                    //                            }
                    
                    self.testCalculations(budget: self.budget, margin: self.margin, sales: self.todaysSales)
                    
                }
            }
            }, withCancel: nil)
        
        
    }
    
    
    @IBAction func plusSaleButtonPressed(_ sender: UIButton) {
        addASale()
    }
    
    @IBAction func minusSaleButtonPressed(_ sender: UIButton) {
        minusASale()
    }
    
    
    
    @IBAction func backbuttonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func bringInData() {
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                self.productTitleLbl.text = "\((dictionary["title"] as? String)!)"
                self.todaysSalesLbl.text = "\((dictionary["todaysSales"] as? Int)!)"
                //self.budgetLbl.text = "\((dictionary["budget"] as? Double)!)"
                //self.marginLbl.text = "\((dictionary["margin"] as? Double)!)"
                
                
                if let marginFb = dictionary["margin"] as? Double, let budgetFb = dictionary["budget"] as? Double, let todaysSalesFb = dictionary["todaysSales"] as? Int, let _totalAdSpend = dictionary["totalAdSpend"] as? Double, let _totalSales = dictionary["totalSales"] as? Double {
                    self.budget = budgetFb
                    self.margin = marginFb
                    self.todaysSales = todaysSalesFb
                    self.totalAdSpend = _totalAdSpend
                    self.totalSales = _totalSales
                    
                    //self.budgetLbl.text = self.formatter.string(from: self.budget as NSNumber)
                    //self.marginLbl.text = self.formatter.string(from: self.margin as NSNumber)
                    self.budgetMarginLbl.text = "Budget: \(self.formatter.string(from:self.budget as NSNumber)!) | Margin: \(self.formatter.string(from:self.margin as NSNumber)!)"
                    self.todaysSalesLbl.text = "\(self.todaysSales)"
                    self.totalSalesLbl.text = "\(Int(self.totalSales))"
                    self.totalAdSpendLbl.text = self.formatter.string(from: self.totalAdSpend as NSNumber)
                    self.testCalculations(budget: self.budget, margin: self.margin, sales: self.todaysSales)
                    
                }
                
                
                
                
            }
            
            }, withCancel: nil)
        
    }
    
    
    func addASale(){
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let _todaysSales = dictionary["todaysSales"] as? Int, let _totalSales = dictionary["totalSales"] as? Double{
                    
                    self.todaysSales = _todaysSales
                    self.totalSales = _totalSales
                    
                    
                    
                    self.totalSales += 1
                    self.todaysSales += 1
                    productReference.child("todaysSales").setValue(self.todaysSales)
                    productReference.child("totalSales").setValue(self.totalSales)
                    self.todaysSalesLbl.text = "\(self.todaysSales)"
                    self.totalSalesLbl.text = "\(Int(self.totalSales))"
                    
                    self.testCalculations(budget: self.budget, margin: self.margin, sales: self.todaysSales)
                    
                }
            }
            }, withCancel: nil)
    }
    
    
    func minusASale(){
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let _todaysSales = dictionary["todaysSales"] as? Int, let _totalSales = dictionary["totalSales"] as? Double{
                    
                    self.todaysSales = _todaysSales
                    self.totalSales = _totalSales
                    
                    
                    if self.todaysSales > 0{
                        self.totalSales -= 1
                        self.todaysSales -= 1
                        productReference.child("todaysSales").setValue(self.todaysSales)
                        productReference.child("totalSales").setValue(self.totalSales)
                        self.todaysSalesLbl.text = "\(self.todaysSales)"
                        self.totalSalesLbl.text = "\(Int(self.totalSales))"
                        
                        self.testCalculations(budget: self.budget, margin: self.margin, sales: self.todaysSales)
                    }
                    
                }
            }
            }, withCancel: nil)
    }
    
    
    
    func testCalculations(budget: Double, margin: Double, sales: Int){
        
        switch budget {
        case 0 ... 9:
            if sales == 0{
                nextDayBudget = budget
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 1 ... 2 ~= sales {
                nextDayBudget = margin
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 3 ... 4 ~= sales {
                nextDayBudget = margin + 10
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else{
                nextDayBudget = margin + 15
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 10 ... 14:
            if 0 ... 1 ~= sales {
                nextDayBudget = budget
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 2 ... 3 ~= sales {
                nextDayBudget = margin * 2
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 4 ... 5 ~= sales {
                nextDayBudget = margin * 2 + 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 2 + 10
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 15 ... 19:
            if sales == 0 {
                nextDayBudget = budget - 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 1 ... 2 ~= sales {
                nextDayBudget = margin + 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 3 ... 5 ~= sales  {
                nextDayBudget = margin + 15
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 20 ... 24:
            if 0 ... 1 ~= sales {
                nextDayBudget = budget - 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 2 ... 3 ~= sales {
                nextDayBudget = margin * 2
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 4 ... 6 ~= sales  {
                nextDayBudget = margin * 2 + 10
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 2 + 20
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 25 ... 34:
            if 0 ... 1 ~= sales  {
                nextDayBudget = budget - 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 2 ... 3 ~= sales {
                nextDayBudget = margin * 2 + 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 4 ... 6 ~= sales  {
                nextDayBudget = margin * 2 + 15
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 2 + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 35 ... 49:
            if 0 ... 2 ~= sales   {
                nextDayBudget = budget - 10
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 3 ... 5 ~= sales  {
                nextDayBudget = margin * 3 + 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 6 ... 8 ~= sales  {
                nextDayBudget = margin * 3 + 20
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 3 + 45
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 50 ... 74:
            if 0 ... 3 ~= sales  {
                nextDayBudget = budget - 15
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 4 ... 7 ~= sales {
                nextDayBudget = margin * 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 8 ... 11 ~= sales  {
                nextDayBudget = margin * 5 + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 5 + 50
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 75 ... 99:
            if 0 ... 5 ~= sales  {
                nextDayBudget = budget - 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 6 ... 11 ~= sales {
                nextDayBudget = margin * 5 + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 12 ... 17 ~= sales  {
                nextDayBudget = margin * 5 + 50
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 5 + 75
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 100 ... 124:
            if 0 ... 7 ~= sales  {
                nextDayBudget = budget - 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 8 ... 14 ~= sales {
                nextDayBudget = margin * 10
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 15 ... 19 ~= sales  {
                nextDayBudget = margin * 10 + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 10 + 50
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 125 ... 149:
            if 0 ... 10 ~= sales  {
                nextDayBudget = budget - 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 11 ... 17 ~= sales {
                nextDayBudget = margin * 10 + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 18 ... 22 ~= sales {
                nextDayBudget = margin * 10 + 50
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 150 ... 174:
            if 0 ... 12 ~= sales {
                nextDayBudget = budget - 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 13 ... 19 ~= sales{
                nextDayBudget = margin * 10 + 50
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 20 ... 26 ~= sales {
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 10 + 100
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 175 ... 199:
            if 0 ... 14 ~= sales {
                nextDayBudget = budget - 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if 15 ... 24 ~= sales {
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if 25 ... 34 ~= sales {
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 10 + 100
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
        case 200 ... 100000000000:
            if sales == 0 || sales == 1 || sales == 2 || sales == 3 {
                nextDayBudget = budget - 15
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }else if sales == 4 || sales == 5 || sales == 6 || sales == 7{
                nextDayBudget = margin * 2 + 5
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else if sales == 8 || sales == 9 || sales == 10 || sales == 11 {
                nextDayBudget = margin * 2 + 15
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
                
            }else{
                nextDayBudget = margin * 2 + 25
                nextDayBudgetLbl.text = formatter.string(from: nextDayBudget as NSNumber)
                statCalculations(margin: margin)
            }
            
            
            
            
            
        default:
            print("Nothing???")
        }
    }
    
    func statCalculations(margin: Double){
        
        let productReference = FIRDatabase.database().reference().child("users").child(uid!).child("products").child(productAutoId)
        
        productReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                if let _totalSales = dictionary["totalSales"] as? Double, let _totalAdSpend = dictionary["totalAdSpend"] as? Double, let _budget = dictionary["budget"] as? Double  {
                    let blank = 0.0
                    self.totalSales = _totalSales
                    self.totalAdSpend = _totalAdSpend
                    self.budget = _budget
                    
                    
                    if self.totalSales != 0{
                        self.cpa = self.totalAdSpend / self.totalSales
                        print("endkjfndf")
                        self.cpaLbl.text = self.formatter.string(from: self.cpa as NSNumber)
                    }else{
                        self.cpaLbl.text = self.formatter.string(from: blank as NSNumber)
                    }
                    
                    
                    
                    
                    
                    if self.totalAdSpend != 0.0{
                        self.roi = ((self.totalSales * margin) - self.totalAdSpend)/self.totalAdSpend
                        self.roiLbl.text = self.percentFormat.string(from: self.roi as NSNumber)
                        self.ratingCalculator(roi: self.roi)
                        print("Hello")
                        
                        
                    }else{
                        self.roiLbl.text = self.percentFormat.string(from: blank as NSNumber)
                        self.ratingCalculator(roi: self.roi)
                    }
                    
                    
                    
                    
                    
                    if self.cpa != 0.0{
                        self.projSales = self.budget / self.cpa
                        print("dggd")
                        self.projSalesLbl.text = "\(Int(self.projSales))"
                    }else{
                        self.projSalesLbl.text = "\(Int(0))"
                    }
                    
                    
                    
                    
                    //self.testCalculations(budget: self.budget, margin: self.margin, sales: self.todaysSales)
                    
                }
            }
            }, withCancel: nil)
        
    }
    
    
    
    
    
    
    
    func ratingCalculator(roi: Double){
        switch roi {
        case 0.5 ... 100:
            starRatingImg.image = UIImage(named: "5 Stars")
        case 0.4 ... 0.49:
            starRatingImg.image = UIImage(named: "4 Stars")
        case 0.2 ... 0.39:
            starRatingImg.image = UIImage(named: "3 Stars")
        case 0.01 ... 0.19:
            starRatingImg.image = UIImage(named: "2 Stars")
        case -0.1000 ... 0.0:
            starRatingImg.image = UIImage(named: "1 Star")
        default:
            print("Nothing")
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
