//
//  Product.swift
//  Leaf
//
//  Created by Justin  on 11/14/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import Foundation
import Firebase

class Product: NSObject {
    private var _title: String!
    private var _budget: Double!
    private var _margin: Double!
    private var _todaysSales: Int!
    private var _totalSales: Double!
    private var _totalAdSpend: Double!
    private var _postKey: String!
   private var _postRef: FIRDatabaseReference!
    
    
    var title: String {
        return _title
    }
    
    var budget: Double {
        return _budget
    }
    
    var margin: Double {
        return _margin
    }
    
    var todaysSales: Int {
        return _todaysSales
    }
    
    var totalSales: Double {
        return _totalSales
    }
    
    var totalAdSpend: Double {
        return _totalAdSpend
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(title: String, budget: Double, margin: Double, dailySales: Int, totalSales: Double, totalAdSpend: Double) {
        self._title = title
        self._budget = budget
        self._margin = margin
        self._todaysSales = dailySales
        self._totalSales = totalSales
        self._totalAdSpend = totalAdSpend
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let title = postData["title"] as? String {
            self._title = title
        }
        
        if let budget = postData["budget"] as? Double {
            self._budget = budget
        }
        
        if let margin = postData["margin"] as? Double {
            self._margin = margin
        }
        
        if let todaysSales = postData["todaysSales"] as? Int {
            self._todaysSales = todaysSales
        }
        if let totalSales = postData["totalSales"] as? Double {
            self._totalSales = totalSales
        }
        if let totalAdSpend = postData["totalAdSpend"] as? Double {
            self._totalAdSpend = totalAdSpend
        }
        
        _postRef = DataService.ds.REF_PRODUCTS.child(_postKey)
        
    }
    
    
    
    
    
    
}
