//
//  Class.swift
//  hearthstonefinder
//
//  Created by Yosemite on 11/9/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import Foundation
import CoreData

class Class: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String) -> Class {
        let newClass = NSEntityDescription.insertNewObjectForEntityForName("Class", inManagedObjectContext: moc) as! Class
        newClass.name = name
        return newClass
    }
}
