//
//  Card+CoreDataProperties.swift
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

extension Card {

    @NSManaged var attack: NSNumber?
    @NSManaged var attribute: String?
    @NSManaged var cardId: String?
    @NSManaged var cost: NSNumber?
    @NSManaged var faction: String?
    @NSManaged var flavor: String?
    @NSManaged var health: NSNumber?
    @NSManaged var img: String?
    @NSManaged var name: String?
    @NSManaged var howToGet: String?
    @NSManaged var race: String?
    @NSManaged var type: String?
    @NSManaged var rarity: String?
    @NSManaged var text: String?
    @NSManaged var hero: Class?
    @NSManaged var set: NSManagedObject?
    @NSManaged var count: NSNumber?
    @NSManaged var craft: NSNumber?

}
