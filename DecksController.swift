//
//  DecksController.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/7/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData

class DecksController: UITableViewController , NSFetchedResultsControllerDelegate {
    
    // Managed Object Context
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Controller for Fetching Sets
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    var cardResultsController: NSFetchedResultsController = NSFetchedResultsController()
    var allCards: [Card] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        fetchedResultsController = getFetchedResultController()
        cardResultsController = getCardResultController()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        for d in fetchedResultsController.fetchedObjects! {
            self.getCardsData(d as! Deck)
        }
    }

    func getCardsData(deck: Deck){
        
        var classCheck = true
        
        if (deck.card1!.count != 0 || deck.card2!.count != 0) {
            return
        }
        
        if (allCards.isEmpty) {
            do {
                try cardResultsController.performFetch()
            } catch _ {
            }
            allCards = cardResultsController.fetchedObjects as! [Card]
        }
        
        let separators = NSCharacterSet(charactersInString: ":;")
        let ids = deck.idList
        
        // Split based on characters.
        let parts = ids!.componentsSeparatedByCharactersInSet(separators)
            for(var i = 0; (i+1) < parts.count; ++i){
                if let card = parts[i] as String?{
                    ++i;
                    if let count = parts[i] as String?{
                        if(count.containsString("1")){
                            if let found = (allCards.filter(){ $0.cardId! == card })[0] as Card?{
                                deck.addCard1(found)
                                print(found.name!)
                                if(classCheck){
                                    if let hero = found.hero{
                                        deck.classRelation = hero;
                                        classCheck = false;
                                    }
                                }
                                self.save()
                            }
                        }else if(count.containsString("2")){
                            if let found = (allCards.filter(){ $0.cardId! == card })[0] as Card?{
                                deck.addCard2(found)
                                print(found.name!)
                                if(classCheck){
                                    if let hero = found.hero{
                                        deck.classRelation = hero;
                                        classCheck = false;
                                    }
                                }
                                self.save()
                            }
                        }
                    }
                }
        }
        self.save()
        self.tableView.reloadData()
    }
    func save(){
        do{
            try self.managedObjectContext.save()
        } catch _ as NSError {
            print("error with core data card save")
        }
    }

    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest("Deck"), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func getCardResultController() -> NSFetchedResultsController {
        cardResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest("Card"), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return cardResultsController
    }
    
    func taskFetchRequest(type: String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: type)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRowsInSection = fetchedResultsController.sections?[section].numberOfObjects {
            return numberOfRowsInSection
        } else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DeckCell
        let d = fetchedResultsController.objectAtIndexPath(indexPath) as! Deck
       
        cell.name.text = d.name
        //getCardsData(d)
        d.dustCost()
        cell.dust.text = "\(d.dust!)"
        
        if let image = d.classRelation?.image{
            cell.heroImage.kf_setImageWithURL(NSURL(string: image)!)
        } else {
            cell.heroImage.image = UIImage(named:"titleimg")
        }
        
        
        cell.heroImage.alpha = 0.6
        cell.heroImage.layer.contentsRect = CGRectMake(0.25, 0.25, 0.50, 0.1);
        
        //cell.dust.text = d.dust
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passDeck"{
            let secondViewController : DeckController = segue.destinationViewController as! DeckController
            
            let indexPath = self.tableView.indexPathForSelectedRow //get index of data for selected row
            
            let d = fetchedResultsController.objectAtIndexPath(indexPath!) as! Deck
            secondViewController.passData = d.name // get data by index and pass it to second view controller
            
        }
    }

}
