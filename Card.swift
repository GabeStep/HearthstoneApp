//
//  Card.swift
//  hearthstonefinder
//
//  Created by Yosemite on 11/9/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import Foundation
import CoreData

class Card: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc: NSManagedObjectContext, cardID: String) -> Card {
        let newCard = NSEntityDescription.insertNewObjectForEntityForName("Card", inManagedObjectContext: moc) as! Card
        newCard.cardId = cardID;
        newCard
        return newCard;
    }
}
