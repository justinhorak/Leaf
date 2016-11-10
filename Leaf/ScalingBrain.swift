//
//  ScalingBrain.swift
//  Leaf
//
//  Created by Justin  on 11/7/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import Foundation

class ScalingBrain {

    func calculateScaling(budget: Double, margin: Double, sales: Double) -> Double{
        var nextDayBudget = budget
        switch budget {
        case 0 ... 5:
            if sales == 0{
                nextDayBudget = budget
            }else if sales == 1 || sales == 2{
                nextDayBudget = margin
            }else if sales == 3 || sales == 4{
                nextDayBudget = margin + 10
            }else{
                nextDayBudget = margin + 15
            }
        default:
            print("Nothing")
        }
        
        
        print(nextDayBudget)
        return nextDayBudget
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
