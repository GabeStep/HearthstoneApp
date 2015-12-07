//
//  Deck+CoreDataProperties.swift
//  
//
//  Created by Steven Hawley on 12/6/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Deck {

    @NSManaged var name: String?
    @NSManaged var link: String?
    @NSManaged var idList: String?
    @NSManaged var card1: NSSet?
    @NSManaged var classRelation: Class?
    @NSManaged var card2: NSSet?
    @NSManaged var tier: NSNumber?

}
