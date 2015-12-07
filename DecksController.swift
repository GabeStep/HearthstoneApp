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
        do {
            try cardResultsController.performFetch()
        } catch _ {
        }
        allCards = cardResultsController.fetchedObjects as! [Card]
    }

    func getCardsData(deck: Deck){
        
        var classCheck = true;
        if let _ = deck.classRelation{
            classCheck = false;
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
                                if(classCheck){
                                    if let hero = found.hero{
                                        deck.classRelation = hero;
                                        classCheck = false;
                                    }
                                }
                            }
                        }else if(count.containsString("2")){
                            if let found = (allCards.filter(){ $0.cardId! == card })[0] as Card?{
                                deck.addCard1(found)
                                if(classCheck){
                                    if let hero = found.hero{
                                        deck.classRelation = hero;
                                        classCheck = false;
                                    }
                                }
                            }
                        }
                    }
                }
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
        getCardsData(d)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
