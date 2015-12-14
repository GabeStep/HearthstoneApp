//
//  ViewController.swift
//  hearthstonefinder
//
//  Created by Yosemite on 11/8/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData
import Parse
import SwiftHTTP
import SwiftyJSON

class DownloadController: UIViewController {
    var cardsEnabled = false
    var decksEnabled = false
    
    @IBOutlet weak var update: UIButton!
    //Array for classes
    var classes = Dictionary<String,Class>()
    
    //Cards
    var allCards: [Card] = []
    
    // error list
    enum errors : ErrorType {
        case fetchError
    }
    
    func downloadDecks() {
        let query = PFQuery(className:"decks")
        query.findObjectsInBackgroundWithBlock {
            (decks: [PFObject]?, error: NSError?) -> Void in
            if error == nil && decks != nil {
                for deck in decks!{
                    self.saveDeck(deck)
                }
                
                // save moc
                do{
                    try self.moc.save()
                } catch _ as NSError {
                    print("error with core data card save")
                }
                
            } else {
                print(error)
            }
        }
    }
    
    func save(){
        do{
            try self.moc.save()
        } catch _ as NSError {
            print("error with core data card save")
        }
    }

    func updateData() {
        
    }
    
    // object to keep the same managed object context
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardRequest = NSFetchRequest(entityName: "Card")
        let deckRequest = NSFetchRequest(entityName: "Deck")
        do{
            guard let cardResult = try self.moc.executeFetchRequest(cardRequest) as? [Card] else {
                throw errors.fetchError
            }
            if cardResult.count == 0{
                self.getCards(){ (response) in
                    if response{
                        self.cardsEnabled = true
                        self.decksEnabled = true
                    }
                }
            } else {
                print("cards found: \(cardResult.count)")
                self.cardsEnabled = true;
            }
        } catch {
            print("fetch error:")
        }
        
        do{
            guard let deckResult = try self.moc.executeFetchRequest(deckRequest) as? [Deck] else {
                throw errors.fetchError
            }
            if deckResult.count == 0{
                self.downloadDecks()
            } else {
                print("Decks found: \(deckResult.count)")
                self.decksEnabled = true
            }
        } catch {
            print("fetch error:")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        // unlock buttons
    }
    
    // function to grab cards json from mashape api
    func getCards(callback: Bool -> ()){
        
        do {
            let opt = try HTTP.GET("https://omgvamp-hearthstone-v1.p.mashape.com/cards?collectible=1", headers: ["X-Mashape-Key": "EoiFVOryjymshhQcApwmhvoGBGRIp1Br4khjsnlCIqJTVvsSph"])
            opt.start { response in
                print(response)
                let d = NSData(data: response.data)
                self.parseCards(d)
                callback(true)
            }
        } catch let error {
            callback(true)
            print("couldn't serialize the paraemeters: \(error)")
        }
    }
        // core data saving
    
    func saveDeck(deck: PFObject){
        if let name = deck["name"] {
            let newDeck = Deck.createInManagedObjectContext(moc, name: name as! String)
            if let ids = deck["idList"] as! String?{
                newDeck.idList = ids
            }
            if let link = deck["deckLink"] as! String?{
                newDeck.link = link
            }
            if let tier = deck["tier"] as! String?{
                if let num = Int(tier){
                    newDeck.tier = NSNumber(integer:num)
                }
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        // Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        // Only allow Portrait
        return UIInterfaceOrientation.Portrait
    }
    
    // function to parse out the card call.
    func parseCards(data: NSData){

        let json = JSON(data: data)

        //If json is .Dictionary
        for (setName,subJson):(String, JSON) in json {

            let cs = Set.createInManagedObjectContext(moc, name: setName)

            for (_,inner):(String, JSON) in subJson {
                let c = self.toCard(inner, currentSet: cs)
                if(c.cardId != "ERROR"){
                    allCards.append(c);
                }else{
                    moc.deleteObject(c)
                }
            }
            if(cs.cards?.count == 0){
                moc.deleteObject(cs)
            }
        }
        
        do{
            try moc.save()
        } catch _ as NSError {
            print("error with core data card save")
        }
    }
    
    //make a class
    func createClass(className:String){
        classes[className] = Class.createInManagedObjectContext(moc, name: className)
    }
    // Convert Dictionary to Card Class instance
    // not sure if necesary just doing it for now
    func toCard(c: JSON, currentSet: Set) -> Card{
        if let t = c["type"].string{
            if t == "Hero"{
                if let s = c["cardSet"].string{
                    if s == "Basic" {
                        if let x = c["playerClass"].string{
                            if let hero = classes[x]{
                                if let image = c["img"].string{
                                    hero.image = image
                                }
                            }else{
                                self.createClass(x)
                                if let image = c["img"].string{
                                    classes[x]!.image = image
                                }
                            }
                        }
                    }
                }
                return Card.createInManagedObjectContext(moc, cardID: "ERROR")
            }
        }
        if let y = c["cardId"].string{
            let newCard = Card.createInManagedObjectContext(moc, cardID: y)
            newCard.set = currentSet

            if let x = c["cost"].number{
                newCard.cost = x
            }
            
            if let x = c["faction"].string{
                newCard.faction = x
            }
            
            if let x = c["flavor"].string{
                newCard.flavor = x
            }
            
            if let x = c["health"].number{
                newCard.health = x
            }
            
            if let x = c["howToGet"].string{
                newCard.howToGet = x
                newCard.craft = NSNumber(bool: false)
            }
            
            if let x = c["name"].string{
                newCard.name = x
            }
            
            if let x = c["playerClass"].string{
                if let z = classes[x]{
                    newCard.hero = z
                }else{
                    self.createClass(x)
                    newCard.hero = classes[x]
                }
            }
            
            if let x = c["img"].string{
                newCard.img = x
            }
            
            if let x = c["race"].string {
                newCard.race = x
            }
        
            if let x = c["rarity"].string{
                newCard.rarity = x
            }
        
            if let x = c["type"].string{
                newCard.type = x
            }
            
            return newCard
        }
        
        return Card.createInManagedObjectContext(moc, cardID: "ERROR")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if(self.decksEnabled && identifier == "decks"){
            return true
        }
        if(self.cardsEnabled && identifier == "cards"){
            return true
        }
        return false
    }


}

