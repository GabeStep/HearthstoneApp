//
//  Set.swift
//  hearthstonefinder
//
//  Created by Yosemite on 11/9/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import Foundation
import CoreData

class Set: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String) -> Set {
        let newSet = NSEntityDescription.insertNewObjectForEntityForName("Set", inManagedObjectContext: moc) as! Set
        newSet.name = name
        return newSet;
    }
}
