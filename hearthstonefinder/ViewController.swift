//
//  ViewController.swift
//  hearthstonefinder
//
//  Created by Yosemite on 11/8/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    //Array for classes
    var classes = Dictionary<String,Class>()
    
    // error list
    enum errors : ErrorType {
        case fetchError
    }
    
    // object to keep the same managed object context
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cardRequest = NSFetchRequest(entityName: "Class")
        do{
            guard let cardResult = try self.moc.executeFetchRequest(cardRequest) as? [Class] else {
                throw errors.fetchError
            }
            if cardResult.count == 0{
                self.getCards()
            } else {
                print("cards found: \(cardResult.count)")
            }
        } catch {
            print("fetch error:")
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //function to grab cards json from mashape api
    // needs revision to meet security thingys
    // right now I just added thingy to info.plist to allow
    func getCards(){
        
        // mashape url
        let url = NSURL(string: "https://omgvamp-hearthstone-v1.p.mashape.com/cards?collectible=1")
        
        //setting up the request
        let request = NSMutableURLRequest(URL: url!)
        request.addValue("EoiFVOryjymshhQcApwmhvoGBGRIp1Br4khjsnlCIqJTVvsSph", forHTTPHeaderField: "X-Mashape-Key")
        
        
            // creating a task for getting the data with code block
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error in
                
                if error != nil{
                    print("error")
                }else{
                    print("AsSychronous")
                }
                
                // recieved data
                let d = NSData(data: data!)
                self.parseCards(d)
                
            }
            task.resume()
        
        //NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: response)
    }
    
    // core data saving
    func saveCards(){
        
    }
    
    
    // function to parse out the card call.
    func parseCards(data: NSData){
        
        let parsedObject: AnyObject?
        do {
            parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            
        } catch let error as NSError{
            print(error)
            return
        }catch {
            fatalError()
        }
        var allCards = [String: [Card]]()
        
        if let topLeveObj = parsedObject as? Dictionary<String,AnyObject>{
            for(key,value) in topLeveObj {
                if let items = value as?  Array<Dictionary<String,AnyObject>> {
                    var set = [Card]()
                    let cs = Set.createInManagedObjectContext(moc, name: key)
                    for i in items {
                        set.append(self.toCard(i, currentSet: cs))
                    }
                    print(key)
                    for c in set{
                        print("\t" + c.name!)
                        
                    }
                    allCards[key] = set
                }
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
    func toCard(c: Dictionary<String,AnyObject>, currentSet: Set) -> Card{
        
        if let y = c["cardId"] as? String{
            let newCard = Card.createInManagedObjectContext(moc, cardID: y)
            newCard.set = currentSet
            if let x = c["cost"] as? NSNumber{
                newCard.cost = x
            }
            
            if let x = c["faction"] as? String{
                newCard.faction = x
            }
            
            if let x = c["flavor"] as? String{
                newCard.flavor = x
            }
            
            if let x = c["health"] as? NSNumber{
                newCard.health = x
            }
            
            if let x = c["howToGet"] as? String{
                newCard.howToGet = x
            }
            
            if let x = c["name"] as? String{
                newCard.name = x
            }
            
            if let x = c["playerClass"] as? String{
                if let z = classes[x]{
                    newCard.hero = z
                }else{
                    self.createClass(x)
                    newCard.hero = classes[x]
                }
            }
            
            if let x = c["img"] as? String{
                newCard.img = x
            }
            
            if let x = c["race"] as? String{
                newCard.race = x
            }
        
            if let x = c["rarity"] as? String{
                newCard.rarity = x
            }
        
            if let x = c["type"] as? String{
                newCard.type = x
            }
            
            return newCard
        }
        return nil as Card!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

