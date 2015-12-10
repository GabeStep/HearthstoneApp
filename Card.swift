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
        newCard.count = 0;
        newCard.craft = NSNumber(bool: true)
        return newCard;
    }
    
    func dustCost() -> NSNumber? {
        if(Bool(self.craft!)){
            if(self.rarity! == "Common"){
                return 40;
            } else if(self.rarity! == "Rare"){
                return 100;
            } else if(self.rarity! == "Epic"){
                return 400;
            } else if(self.rarity! == "Legendary"){
                return 1600;
            }
        }
        return 0;
    }
}
