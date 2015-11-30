//
//  MyCardsController.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 11/25/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData

class MyCardsController: UITableViewController,  NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    var searchResultsController: NSFetchedResultsController?
    var resultSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        fetchedResultsController = getFetchedResultController()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        
        let fetchRequest = taskFetchRequest()
        if(searchController.searchBar.text!.characters.count > 0){
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchController.searchBar.text!)
            fetchRequest.predicate = predicate
        }
        
        searchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try searchResultsController!.performFetch()
        } catch _ {
        }
        self.tableView.reloadData()
    }
    
    //MARK: NSFetchRequest
   // func fetchedResultsControllerForTableView(tableView: UITableView) -> NSFetchedResultsController? {
     //   return tableView == searchController?.searchResultsTableView ? searchResultsController? : fetchedResultsController?
    //}
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Card")
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
        if (self.resultSearchController.active)
        {
            if let numberOfRowsInSection = searchResultsController!.sections?[section].numberOfObjects {
                return numberOfRowsInSection
            } else {
                return 0
            }
        } else {
            if let numberOfRowsInSection = fetchedResultsController.sections?[section].numberOfObjects {
                return numberOfRowsInSection
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CardCell
        var c:Card
        
        if (self.resultSearchController.active)
        {
            c = searchResultsController!.objectAtIndexPath(indexPath) as! Card
        } else {
            c = fetchedResultsController.objectAtIndexPath(indexPath) as! Card
        }
        let count = (c.valueForKey("count") as! NSNumber?)?.integerValue
        
        if(count == 1){
            cell.contentView.backgroundColor = UIColor.redColor()
        } else if(count == 2){
            cell.contentView.backgroundColor = UIColor.blueColor()
        } else {
            cell.contentView.backgroundColor = UIColor.whiteColor()
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        cell.userInteractionEnabled = true;
        cell.addGestureRecognizer(swipeRight)
        cell.addGestureRecognizer(swipeLeft)
        
        cell.name.text = c.name
        cell.count.text = "\(count!)"
        
        return cell
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            let location : CGPoint = gesture.locationInView(self.tableView)
            let indexPath:NSIndexPath = self.tableView.indexPathForRowAtPoint(location)!
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                var managedObject:NSManagedObject
                
                if (self.resultSearchController.active)
                {
                    managedObject = searchResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
                }else{
                    managedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                }
                let oldc = managedObject.valueForKey("count") as? NSNumber
                
                if(oldc?.integerValue > 0){
                    managedObject.setValue((oldc?.integerValue)! - 1, forKey: "count")
                    do {
                        try managedObjectContext.save()
                    } catch _ {
                        }
                }
                
            case UISwipeGestureRecognizerDirection.Left:
                var managedObject:NSManagedObject
                if (self.resultSearchController.active)
                {
                    managedObject = searchResultsController!.objectAtIndexPath(indexPath) as! NSManagedObject
                }else{
                    managedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                }
                let oldc = managedObject.valueForKey("count") as? NSNumber
                
                if(oldc?.integerValue < 2){
                    managedObject.setValue((oldc?.integerValue)! + 1, forKey: "count")
                    do {
                        try managedObjectContext.save()
                    } catch _ {
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: - TableView Refresh
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
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
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
            let oldc = managedObject.valueForKey("count") as? NSNumber
            managedObject.setValue((oldc?.integerValue)! + 1, forKey: "count")
            do {
                try managedObjectContext.save()
            } catch _ {
            }
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
