//
//  Set+CoreDataProperties.swift
//  hearthstonefinder
//
//  Created by Yosemite on 11/9/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Set {

    @NSManaged var name: String?
    @NSManaged var all: NSNumber?
    @NSManaged var cards: NSSet?

}
