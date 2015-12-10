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
    func dustCost(){
        var totalDust:Float = 0;
        for c in self.card1! {
            let card = c as! Card
            if let dust = card.dustCost() {
                if(card.count == 0){
                    totalDust += dust.floatValue
                }
            }
            
        }
        for c in self.card2! {
            let card = c as! Card
            if let dust = card.dustCost() {
                    if(card.count == 1){
                    totalDust += dust.floatValue
                }else if(card.count == 0){
                    totalDust += dust.floatValue * 10
                }
            }
        }
        print(totalDust)
        self.dust = NSNumber(float: totalDust)
    }
}
