//
//  MainVC.swift
//  Leaf
//
//  Created by Justin  on 11/5/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import CoreData


extension UILabel{
    func addTextSpacing(spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: self.text!.characters.count))
        self.attributedText = attributedString
    }
}

class MainVC: UIViewController {
    
    let formatter = NumberFormatter()
    let percentFormat = NumberFormatter()
    
    
    
    
    
    @IBOutlet weak var nextDayBudgetLabel: UILabel!
    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var differenceInBudget: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    var itemToEdit: Item!
    
    var nextDayBudget = 0.0
    
    
    
    //Stats
    
    @IBOutlet weak var cpaLabel: UILabel!
    @IBOutlet weak var completeTotalSalesLable: UILabel!
    @IBOutlet weak var totalAdSpendLable: UILabel!
    @IBOutlet weak var roiLabel: UILabel!
    @IBOutlet weak var productGradeLable: UILabel!
    
    @IBOutlet weak var statView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .currency
        percentFormat.numberStyle = .percent
        
        loadItemData()
        
    }
    
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        let alertController: UIAlertController = UIAlertController(title: "Delete \((itemToEdit!.title)!) ?", message: "Deleting this product will also delete its data.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(action:UIAlertAction) in
            
            //Do Nothing
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {(action:UIAlertAction) in
            if self.itemToEdit != nil{
                context.delete(self.itemToEdit)
                ad.saveContext()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        print("Delete")
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        statCalculator()
        statView.isHidden = false
        
        print("Swipe")
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //    @IBAction func statsButtonPressed(_ sender: UIButton){
    //
    //        statView.isHidden = false
    //        statCalculator()
    //
    //
    //
    //    }
    @IBAction func minusButton(_ sender: UIButton) {
        if itemToEdit.totalSales > 0 {
            salesButtonPressedUpdate(x: -1)
            calculateScaling(budget: itemToEdit.budget, margin: itemToEdit.margin, sales: itemToEdit.totalSales)
        }
    }
    
    @IBAction func plusButtonPushed(_ sender: UIButton) {
        salesButtonPressedUpdate(x: 1)
        calculateScaling(budget: itemToEdit.budget, margin: itemToEdit.margin, sales: itemToEdit.totalSales)
    }
    
    func salesButtonPressedUpdate( x: Double) {
        itemToEdit.totalSales += x
        totalSalesLabel.text = "\(Int((itemToEdit.totalSales)))"
        ad.saveContext()
    }
    
    @IBAction func endDayButtonPressed(_ sender: UIButton) {
        
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Yes"){ () -> Void  in
            self.endDay()
            
        }
        
        alertView.addButton("No"){ () -> Void  in
            //self.dismiss(animated: true, completion: nil)
        }
        
        
        alertView.showInfo("Ready to end your Day?", subTitle: " ")
        
        
//        let alertController: UIAlertController = UIAlertController(title: "Ready to End your day?", message: " ", preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: "No", style: .cancel) {(action:UIAlertAction) in
//            
//            //Do Nothing
//        }
//        let yesAction = UIAlertAction(title: "Yes", style: .default) {(action:UIAlertAction) in
//            self.endDay()
//        }
//        
//        alertController.addAction(cancelAction)
//        alertController.addAction(yesAction)
//        
//        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func endDay(){
        if nextDayBudget == itemToEdit.budget{
            
            let warning = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let warningView = SCLAlertView(appearance: warning)
            
            warningView.addButton("Ok"){ () -> Void  in
                self.no()
                
            }
            
            warningView.showWarning("Not Ready Yet", subTitle: "Look's like we should hold off scaling until we get some more sales.")
            
        }else if nextDayBudget > itemToEdit.budget{
            let success = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let successView = SCLAlertView(appearance: success)
            
            successView.addButton("Yes, Scale Up!"){ () -> Void  in
                self.yes()
                
            }
            
            successView.addButton("No, Not Today."){ () -> Void  in
                self.no()
                
            }

            successView.showSuccess("Congratulations", subTitle: "Great sales today, Leaf suggests scaling up. Would you like to update your budget of $\(Int(itemToEdit.budget)) to $\(Int(nextDayBudget))?")
            
            
        }else{
            let noScale = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let noScaleView = SCLAlertView(appearance: noScale)
            
            noScaleView.addButton("Yes, I do."){ () -> Void  in
                self.yes()
                
            }
            
            noScaleView.addButton("No, I'm fine."){ () -> Void  in
                self.no()
                
            }
            
            noScaleView.showError("Hold On...", subTitle: "Look's like we should lower the budget. Would you like to update your budget of $\(Int(itemToEdit.budget)) to $\(Int(nextDayBudget))?")
        }
        
        
        
    }
    
    
    
    
    func yes(){
        resetSales()
        itemToEdit.budget = nextDayBudget
        budgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
        calculateScaling(budget: itemToEdit.budget, margin: itemToEdit.margin, sales: itemToEdit.totalSales)
        ad.saveContext()
        
    }
    
    func no(){
        resetSales()
        calculateScaling(budget: itemToEdit.budget, margin: itemToEdit.margin, sales: itemToEdit.totalSales)
        ad.saveContext()
    }
    
    func endDayMessageTemplate(titleLine: String, messageLine: String){
        
        
        
        resetSales()
        
        let alertController: UIAlertController = UIAlertController(title: titleLine, message: messageLine, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel) {(action:UIAlertAction) in
            self.calculateScaling(budget: self.itemToEdit.budget, margin: self.itemToEdit.margin, sales: self.itemToEdit.totalSales)
            ad.saveContext()
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default) {(action:UIAlertAction) in
            self.itemToEdit.budget = self.nextDayBudget
            self.budgetLabel.text = self.formatter.string(from: self.nextDayBudget as NSNumber)
            self.calculateScaling(budget: self.itemToEdit.budget, margin: self.itemToEdit.margin, sales: self.itemToEdit.totalSales)
            ad.saveContext()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func doneStatButtonPressed(_ sender: UIButton) {
        statView.isHidden = true
    }
    
    
    
    func statCalculator(){
        var cpa = 0.0
        var roi = 0.0
        if itemToEdit.totalAdSpend != 0{
            roi = ((itemToEdit.completeTotalSales * itemToEdit.margin) - itemToEdit.totalAdSpend)/itemToEdit.totalAdSpend
            roiLabel.text = percentFormat.string(from: roi as NSNumber)
            print(roi)
            
            switch roi {
            case 0.5 ... 100:
                productGradeLable.text = "A"
            case 0.4 ... 0.49:
                productGradeLable.text = "B"
            case 0.2 ... 0.39:
                productGradeLable.text = "C"
            case 0.01 ... 0.19:
                productGradeLable.text = "D"
            //case 0.0 ... -0.1000:
                //productGradeLable.text = "F"
                default:
                print("Nothing")
            }
            
            
            
            
            
            if itemToEdit.completeTotalSales != 0{
                cpa = itemToEdit.totalAdSpend / itemToEdit.completeTotalSales
                cpaLabel.text = formatter.string(from: cpa as NSNumber)
                
                
            }
        }else{
            cpaLabel.text = formatter.string(from: cpa as NSNumber)
            roiLabel.text = percentFormat.string(from: roi as NSNumber)
        }
        
        
        
        totalAdSpendLable.text = formatter.string(from: itemToEdit.totalAdSpend as NSNumber)
        completeTotalSalesLable.text = "\(Int(itemToEdit.completeTotalSales))"
        
        
        
        
        
        
        //        switch roi {
        //        case 0.5 ... 100:
        //            print("A")
        //            //Set Product Grade To A
        //        case 0.4 ... 0.49:
        //            print("B")
        //            //Set Product Grade To B
        //        case 0.3 ... 0.39:
        //            print("C")
        //            //Set Product Grade To C
        //        case 0.2 ... 0.29:
        //            print("D")
        //            //Set Product Grade To D
        //        case 0.0 ... 0.1:
        //            print("F")
        //            //Set Product Grade To F
        //        default:
        //            print("Nothing")
        //        }
        
        
        
        
    }
    
    
    func resetSales(){
        itemToEdit.totalAdSpend += itemToEdit.budget
        itemToEdit.completeTotalSales += itemToEdit.totalSales
        
        itemToEdit.totalSales = 0
        totalSalesLabel.text = "\(Int((itemToEdit.totalSales)))"
        ad.saveContext()
    }
    
    func differenceInBudgetCheck(diffInBudget: Double) {
        //let difference = diffInBudget - itemToEdit.budget
        //let totalAmountEarned = itemToEdit.totalSales * itemToEdit.margin
        
        let roi = ((itemToEdit.totalSales * itemToEdit.margin) - itemToEdit.budget)/itemToEdit.budget
        
        if roi < 0 {
            differenceInBudget.textColor = UIColor(red: 254/255, green: 127/255, blue: 131/255, alpha: 1.0)
            arrowImage.image = UIImage(named: "Down")
        }else if roi == 0{
            differenceInBudget.textColor = UIColor(red: 244/255, green: 210/255, blue: 47/255, alpha: 1.0)
            arrowImage.image = UIImage(named: "Neutral")
        }else{
            differenceInBudget.textColor = UIColor(red: 0/255, green: 194/255, blue: 148/255, alpha: 1.0)
            arrowImage.image = UIImage(named: "Up")
        }
        
        differenceInBudget.text = percentFormat.string(from: roi as NSNumber)
        
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            productTitle.text = item.title
            productTitle.addTextSpacing(spacing: 2.0)
            budgetLabel.text = formatter.string(from: item.budget as NSNumber)
            totalSalesLabel.text = "\(Int((item.totalSales)))"
            calculateScaling(budget: item.budget, margin: item.margin, sales: item.totalSales)
            
        }
    }
    
    
    
    
    
    
    func calculateScaling(budget: Double, margin: Double, sales: Double){
        //var nextDayBudget = 0.0
        
        switch budget {
        case 0 ... 9:
            if sales == 0{
                nextDayBudget = budget
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 1 ... 2 ~= sales {
                nextDayBudget = margin
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 3 ... 4 ~= sales {
                nextDayBudget = margin + 10
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin + 15
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 10 ... 14:
            if 0 ... 1 ~= sales {
                nextDayBudget = budget
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 2 ... 3 ~= sales {
                nextDayBudget = margin * 2
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 4 ... 5 ~= sales {
                nextDayBudget = margin * 2 + 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 2 + 10
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 15 ... 19:
            if sales == 0 {
                nextDayBudget = budget - 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 1 ... 2 ~= sales {
                nextDayBudget = margin + 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 3 ... 5 ~= sales  {
                nextDayBudget = margin + 15
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 20 ... 24:
            if 0 ... 1 ~= sales {
                nextDayBudget = budget - 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 2 ... 3 ~= sales {
                nextDayBudget = margin * 2
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 4 ... 6 ~= sales  {
                nextDayBudget = margin * 2 + 10
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 2 + 20
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 25 ... 34:
            if 0 ... 1 ~= sales  {
                nextDayBudget = budget - 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 2 ... 3 ~= sales {
                nextDayBudget = margin * 2 + 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 4 ... 6 ~= sales  {
                nextDayBudget = margin * 2 + 15
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 2 + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 35 ... 49:
            if 0 ... 2 ~= sales   {
                nextDayBudget = budget - 10
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 3 ... 5 ~= sales  {
                nextDayBudget = margin * 3 + 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 6 ... 8 ~= sales  {
                nextDayBudget = margin * 3 + 20
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 3 + 45
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 50 ... 74:
            if 0 ... 3 ~= sales  {
                nextDayBudget = budget - 15
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 4 ... 7 ~= sales {
                nextDayBudget = margin * 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 8 ... 11 ~= sales  {
                nextDayBudget = margin * 5 + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 5 + 50
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 75 ... 99:
            if 0 ... 5 ~= sales  {
                nextDayBudget = budget - 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 6 ... 11 ~= sales {
                nextDayBudget = margin * 5 + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 12 ... 17 ~= sales  {
                nextDayBudget = margin * 5 + 50
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 5 + 75
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 100 ... 124:
            if 0 ... 7 ~= sales  {
                nextDayBudget = budget - 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 8 ... 14 ~= sales {
                nextDayBudget = margin * 10
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 15 ... 19 ~= sales  {
                nextDayBudget = margin * 10 + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 10 + 50
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 125 ... 149:
            if 0 ... 10 ~= sales  {
                nextDayBudget = budget - 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 11 ... 17 ~= sales {
                nextDayBudget = margin * 10 + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 18 ... 22 ~= sales {
                nextDayBudget = margin * 10 + 50
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 150 ... 174:
            if 0 ... 12 ~= sales {
                nextDayBudget = budget - 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 13 ... 19 ~= sales{
                nextDayBudget = margin * 10 + 50
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 20 ... 26 ~= sales {
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 10 + 100
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 175 ... 199:
            if 0 ... 14 ~= sales {
                nextDayBudget = budget - 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if 15 ... 24 ~= sales {
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if 25 ... 34 ~= sales {
                nextDayBudget = margin * 10 + 75
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 10 + 100
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
        case 200 ... 100000000000:
            if sales == 0 || sales == 1 || sales == 2 || sales == 3 {
                nextDayBudget = budget - 15
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }else if sales == 4 || sales == 5 || sales == 6 || sales == 7{
                nextDayBudget = margin * 2 + 5
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else if sales == 8 || sales == 9 || sales == 10 || sales == 11 {
                nextDayBudget = margin * 2 + 15
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
                
            }else{
                nextDayBudget = margin * 2 + 25
                nextDayBudgetLabel.text = formatter.string(from: nextDayBudget as NSNumber)
                differenceInBudgetCheck(diffInBudget: nextDayBudget)
            }
            
            
        default:
            print("Nothing")
        }
        
        
        
        
    }
    
    
}
