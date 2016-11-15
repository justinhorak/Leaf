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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_PRODUCTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let product = Product(postKey: key, postData: postDict)
                        self.products.append(product)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
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
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    @IBAction func newProductButtonPushed(_ sender: UIButton) {
//        
//        
//        let appearance = SCLAlertView.SCLAppearance(
//            kTitleFont: UIFont(name: "SFUIDisplay-Thin", size: 20)!,
//            kTextFont: UIFont(name: "SFUIDisplay-Light", size: 14)!,
//            kButtonFont: UIFont(name: "SFUIDisplay-Light", size: 14)!,
//            showCloseButton: false
//        )
//        let alertView = SCLAlertView(appearance: appearance)
//        
//        
//        
//        let txt = alertView.addTextField("Product Name")
//        txt.textAlignment = .center
//        txt.keyboardAppearance = UIKeyboardAppearance.dark
//        
//        let margin = alertView.addTextField("Product Margin")
//        margin.keyboardType = UIKeyboardType.numberPad
//        margin.keyboardAppearance = UIKeyboardAppearance.dark
//        margin.textAlignment = .center
//        
//        let budget = alertView.addTextField("Ad Spend")
//        budget.keyboardType = UIKeyboardType.numberPad
//        budget.keyboardAppearance = UIKeyboardAppearance.dark
//        budget.textAlignment = .center
//        
//       
//        alertView.addButton("Save", backgroundColor: UIColor(red: 0/255, green: 194/255, blue: 148/255, alpha: 1.0))
//        {
//            
//            if txt.text != "" &&  margin.text != "" && budget.text != ""{
//             
//                let item = Item(context: context)
//                
//                if let title = txt.text{
//                    item.title = title
//                    
//                }
//                
//                if let margin = margin.text{
//                    item.margin = (margin as NSString).doubleValue
//                    
//                }
//                
//                if let budget = budget.text{
//                    item.budget = (budget as NSString).doubleValue
//                    
//                }
//                
//                item.totalDays = 0
//                item.totalSales = 0
//                
//                ad.saveContext()
//            }
//            
//            
//            
//            
//            
//            
//        }
//        
//            
//        alertView.addButton("Cancel", backgroundColor: UIColor(red: 254/255, green: 127/255, blue: 131/255, alpha: 1.0)){
//        }
//        
//            
//            
//            
//            
//            
//            
//            alertView.showEdit("Let's Scale", subTitle: "Fill in the Text Fields to get start.")
//        }
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
//            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
//            return cell
//            return UITableViewCell()
//        }
//        
//        
//        @IBAction func newItemButtonPushed(_ sender: UIButton) {
//            emptyTableMessage.isHidden = true
//            
//        }
//        
//        
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            if let sections = controller.sections {
//                let sectionInfo = sections[section]
//                return sectionInfo.numberOfObjects
//            }
//            
//            return 0
//        }
//        
//        func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
//            
//            let item = controller.object(at: indexPath as IndexPath)
//            cell.configureCell(item: item)
//            
//        }
//        
//        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            
//            if let objs = controller.fetchedObjects , objs.count > 0 {
//                
//                let item = objs[indexPath.row]
//                performSegue(withIdentifier: "MainVC", sender: item)
//            }
//        }
//        
//        
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "MainVC" {
//                if let destination = segue.destination as? MainVC {
//                    if let item = sender as? Item {
//                        destination.itemToEdit = item
//                    }
//                }
//            }
//            
//        }
//        
//        
//        func numberOfSections(in tableView: UITableView) -> Int {
//            
//            if let sections = controller.sections {
//                return sections.count
//                
//            }
//            
//            return 0
//        }
//        
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 80
//        }
//        
//        
//        
//        func startUpImage(){
//            
//            if itemCount == 0 {
//                emptyTableMessage!.isHidden = false
//                print("Show Message")
//            }else{
//                emptyTableMessage!.isHidden = true
//                print("Hid Message")
//            }
//            
//        }
//        
//        func attemptFetch() {
//            
//            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
//            let dateSort = NSSortDescriptor(key: "created", ascending: false)
//            fetchRequest.sortDescriptors = [dateSort]
//            
//            
//            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//            
//            controller.delegate = self
//            
//            self.controller = controller
//            
//            
//            do {
//                
//                try controller.performFetch()
//                
//            } catch {
//                
//                let error = error as NSError
//                print("\(error)")
//                
//            }
//            
//        }
//        
//        
//        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//            tableView.beginUpdates()
//        }
//        
//        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//            tableView.endUpdates()
//        }
//        
//        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//            
//            switch(type) {
//                
//            case.insert:
//                if let indexPath = newIndexPath {
//                    tableView.insertRows(at: [indexPath], with: .fade)
//                }
//                break
//            case.delete:
//                if let indexPath = indexPath {
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                }
//                break
//            case.update:
//                if let indexPath = indexPath {
//                    let cell = tableView.cellForRow(at: indexPath) as! ItemCell
//                    //configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
//                }
//                break
//            case.move:
//                if let indexPath = indexPath {
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                }
//                if let indexPath = newIndexPath {
//                    tableView.insertRows(at: [indexPath], with: .fade)
//                }
//                break
//                
//            }
//        }
    
        
        
        
        
}
