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
            print("1 = \(card.name!)")
            if let dust = card.dustCost() {
                if(card.count == 0){
                    totalDust += dust.floatValue
                }
            }
            
        }
        for c in self.card2! {
            let card = c as! Card
            print("2 = \(card.name!)")
            if let dust = card.dustCost() {
                    if(card.count == 1){
                    totalDust += dust.floatValue
                }else if(card.count == 0){
                    totalDust += dust.floatValue * 2
                }
            }
        }
        print(totalDust)
        self.dust = NSNumber(float: totalDust)
    }
    
    func cardArray() -> [(Int,Card)]{
        var cards: [(Int,Card)] = []
        for c in self.card1! {
            let card = c as! Card
            cards.append((1,card))
            print("1 = \(card.name!)")
            
        }
        for c in self.card2! {
            let card = c as! Card
            cards.append((2,card))
            print("2 = \(card.name!)")
        }
        return cards
    }
    
    func manaCurve() -> [Int] {
        var curve = [Int](count: 11, repeatedValue: 0)

        for c in self.card1! {
            let card = c as! Card
            let val = card.cost?.integerValue
            if (val > 10) {
                curve[10] += 1
            }else{
                curve[val!] += 1
            }
            
        }
        for c in self.card2! {
            let card = c as! Card
            let val = card.cost?.integerValue
            if (val > 10) {
                curve[10] += 1
            }else{
                curve[val!] += 1
            }
            
        }
        return curve;
    }
}
