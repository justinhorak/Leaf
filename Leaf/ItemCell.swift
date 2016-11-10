//
//  ItemCell.swift
//  Leaf
//
//  Created by Justin  on 11/5/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    
    func configureCell(item: Item){
        title.text = item.title?.uppercased()
        
        
    }
    
    
    
    

}
