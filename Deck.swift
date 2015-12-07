//
//  Deck.swift
//  
//
//  Created by Steven Hawley on 12/6/15.
//
//

import Foundation
import CoreData

@objc(Deck)
class Deck: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    // Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String) -> Deck {
        let newClass = NSEntityDescription.insertNewObjectForEntityForName("Deck", inManagedObjectContext: moc) as! Deck
        newClass.name = name
        return newClass
    }
    func addCard1(c: Card){
        self.mutableSetValueForKey("card1").addObject(c)
    }
    
    func addCard2(c: Card){
        self.mutableSetValueForKey("card2").addObject(c)
    }
}
