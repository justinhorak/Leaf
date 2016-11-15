//
//  ItemCell.swift
//  Leaf
//
//  Created by Justin  on 11/5/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    
    var product: Product!
    
    @IBOutlet weak var title: UILabel!
    
    
    
    
    
    func configureCell(product: Product){
        self.product = product
        self.title.text = product.title
        title.text = product.title.uppercased()
        
    }
    
    
    
    

}
