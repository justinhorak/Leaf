//
//  Item+CoreDataProperties.swift
//  Leaf
//
//  Created by Justin  on 11/9/16.
//  Copyright © 2016 Leaf. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var budget: Double
    @NSManaged public var created: NSDate?
    @NSManaged public var margin: Double
    @NSManaged public var title: String?
    @NSManaged public var totalAdSpend: Double
    @NSManaged public var totalDays: Double
    @NSManaged public var totalSales: Double
    @NSManaged public var completeTotalSales: Double

}
