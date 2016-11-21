//
//  ViewController.swift
//  Leaf
//
//  Created by Justin  on 11/5/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit
import CoreData
import Firebase

var itemCount = 1



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyTableMessage: UIImageView!
    
    
    
    @IBOutlet weak var startUpView: UIView!
    var firstStart = true
    var controller: NSFetchedResultsController<Item>!
    var itemToEdit: Item?
    
    var products = [Product]()
    var messagesDictionary = [String: Product]()
    var autoIdArray = [String]()
    
    var selectTitle: String?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
        testFunction()
        //        let defaults = UserDefaults.standard
        //        if !defaults.bool(forKey: "haveRanOnce") {
        //            // First run of app
        //            // Present your message
        
        
        
        
        //            emptyTableMessage!.isHidden = false
        //            // Update defaults
        //            defaults.set(true, forKey: "haveRanOnce")
        //        }
        
        //attemptFetch()
        
        
        
    }
    
    func testFunction(){
        
        let fromId = FIRAuth.auth()!.currentUser!.uid
        
        let userProductRef = FIRDatabase.database().reference().child("users").child(fromId).child("products")
        
    
        
        userProductRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.products = [] // THIS IS THE NEW LINE
            self.autoIdArray = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    //print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Product(postKey: key, postData: postDict)
                        self.autoIdArray.append(key)
                        self.products.append(post)
                        print(self.autoIdArray)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if products.count != 0{
            startUpView.isHidden = true
            print(products.count)
        }else{
            startUpView.isHidden = false
        }
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = products[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell{
            cell.configureCell(product: post)
            return cell
        }else{
            return ItemCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if products.count > 0 {
            
            _ = products[indexPath.row]
            selectTitle = self.autoIdArray[indexPath.row]
            performSegue(withIdentifier: "ScaleVC", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            return
        }
        
        var product = self.products[indexPath.row]
        var autoId = self.autoIdArray[indexPath.row]
        
        FIRDatabase.database().reference().child("users").child(uid).child("products").child(String(describing: autoId)).removeValue(completionBlock: { (error, ref) in
        
            if error != nil {
                print("Failed to delete message:", error)
                return
            }
        
            self.products.remove(at: indexPath.row)
            self.autoIdArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        
        })
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScaleVC" {
            if let colorViewController = segue.destination as? ScalingVC {
                colorViewController.productAutoId = selectTitle
                print("hellllloooooo")
            }
        }
    }
    
        
        
        @IBAction func newProductButtonPushed(_ sender: UIButton) {
            
            
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "SFUIDisplay-Thin", size: 20)!,
                kTextFont: UIFont(name: "SFUIDisplay-Light", size: 14)!,
                kButtonFont: UIFont(name: "SFUIDisplay-Light", size: 14)!,
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            
            
            
            let txt = alertView.addTextField("Product Name")
            txt.textAlignment = .center
            txt.keyboardAppearance = UIKeyboardAppearance.dark
            
            let margin = alertView.addTextField("Product Margin")
            margin.keyboardType = UIKeyboardType.numberPad
            margin.keyboardAppearance = UIKeyboardAppearance.dark
            margin.textAlignment = .center
            
            let budget = alertView.addTextField("Ad Spend")
            budget.keyboardType = UIKeyboardType.numberPad
            budget.keyboardAppearance = UIKeyboardAppearance.dark
            budget.textAlignment = .center
            
            
            alertView.addButton("Save", backgroundColor: UIColor(red: 59/255, green: 226/255, blue: 135/255, alpha: 1.0))
            {
                
                if txt.text != "" &&  margin.text != "" && budget.text != ""{
                    
                    let marginInput = Double(margin.text!)
                    
                    let budgetInput = Double(budget.text!)
                    
                    let fromId = FIRAuth.auth()!.currentUser!.uid
                    
                    
                    
                    let post: Dictionary<String, Any> = [
                        "title": txt.text! as String,
                        "budget": budgetInput! as Double,
                        "margin": marginInput! as Double,
                        "todaysSales": 0 as Int,
                        "totalAdSpend": 0 as Double,
                        "totalSales": 0 as Double
                    ]
                    
                    
                    
                    
                    
                    
                    
                    
                    let firebasePost = DataService.ds.REF_USERS.child(fromId).child("products").childByAutoId()
                    firebasePost.updateChildValues(post, withCompletionBlock: { (error, ref) in
                        if error != nil{
                            print(error)
                            return
                        }
                        
                    })
                    
                    firebasePost.setValue(post)
                    self.testFunction()
                    
                    
                }
                
                
                
                
                
                
            }
            
            
            alertView.addButton("Cancel", backgroundColor: UIColor(red: 255/255, green: 108/255, blue: 112/255, alpha: 1.0)){
            }
            
            
            let icon = UIImage(named:"Logo White")
            let color = UIColor(red: 255/255, green: 108/255, blue: 112/255, alpha: 1.0)

            _ = alertView.showCustom("Let's Scale", subTitle: "Fill in the Text Fiedls to get started.", color: color, icon: icon!)
            
            
            
            //alertView.showEdit("Let's Scale", subTitle: "Fill in the Text Fields to get start.")
        }
       
        
        
        
        
        
}
