//
//  AddItemVC.swift
//  Leaf
//
//  Created by Justin  on 11/5/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var productName: HoshiTextField!
    @IBOutlet weak var productMargin: HoshiTextField!
    @IBOutlet weak var productAdBudget: HoshiTextField!
    
    var mainVC = ViewController()
    
    @IBOutlet weak var alertMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productName.delegate = self
        self.productMargin.delegate = self
        self.productAdBudget.delegate = self
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func textFieldShouldReturn(_ textField: HoshiTextField) -> Bool {
        productName.resignFirstResponder()
        return (true)
    }
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        //mainVC.startUpImage()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if productName.text?.isEmpty ?? false {
            alertMessage.isHidden = false
            alertMessage.text = "Enter a Product Name"
        }else if productMargin.text?.isEmpty ?? false{
            alertMessage.isHidden = false
            alertMessage.text = "Enter your Product Margin"
            
        }else if productAdBudget.text?.isEmpty ?? false{
            alertMessage.isHidden = false
            alertMessage.text = "Enter your Ad Budget"
        }else {
            let item = Item(context: context)
            
            if let title = productName.text{
                item.title = title
                
            }
            
            if let margin = productMargin.text{
                item.margin = (margin as NSString).doubleValue
                
            }
            
            if let budget = productAdBudget.text{
                item.budget = (budget as NSString).doubleValue
                
            }
            
            item.totalDays = 0
            item.totalSales = 0
//            itemCount += 1
//            mainVC.emptyTableMessage?.isHidden = false
            ad.saveContext()
            alertMessage.isHidden = true
            dismiss(animated: true, completion: nil)
            //        _ = navigationController?.popViewController(animated: true)
        }
    }
    
}
