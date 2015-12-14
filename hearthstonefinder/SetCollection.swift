//
//  SetCollection.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/14/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class SetCollection: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    // Managed Object Context
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Controller for Fetching Sets
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "boardBackground.jpg")!)
        fetchedResultsController = getFetchedResultController()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Set")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let numberOfRowsInSection = fetchedResultsController.sections?[section].numberOfObjects {
            return numberOfRowsInSection
        } else {
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SetCollectionCell
        let s = fetchedResultsController.objectAtIndexPath(indexPath) as! Set
        cell.addOrRemove.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.name.text = s.name
        if(Bool(s.all!)){
            cell.addOrRemove.setTitle("Remove all", forState: .Normal)
        }else{
            cell.addOrRemove.setTitle("Add all", forState: .Normal)
        }
        // Configure the cell
    
        return cell
    }
    
    func buttonClicked(sender:UIButton){
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItemAtPoint(buttonPosition)
        if indexPath != nil {
            let s = fetchedResultsController.objectAtIndexPath(indexPath!) as! Set
            s.all! = NSNumber(bool:!Bool(s.all!))
            do {
                try managedObjectContext.save()
            } catch _ {
            }
            self.addOrRemove(Bool(s.all!), set: s)
        }
    }
    
    func addOrRemove(flag: Bool, set: NSManagedObject) {
        let batchRequest = NSBatchUpdateRequest(entityName: "Card") // 2
        let predicate = NSPredicate(format: "set == %@", set)
        
        batchRequest.predicate = predicate
        if(flag){
            batchRequest.propertiesToUpdate = [ "count" : NSNumber(int:2) ] // 3
        }else{
            batchRequest.propertiesToUpdate = [ "count" : NSNumber(int:0) ] // 3
        }
        
        batchRequest.resultType = .UpdatedObjectsCountResultType
        do {
            try self.managedObjectContext.executeRequest(batchRequest) as! NSBatchUpdateResult
        } catch _ {
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView!.reloadData()
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passSet"{
            let secondViewController : MyCardsController = segue.destinationViewController as! MyCardsController
            
            let indexPath = self.collectionView!.indexPathForCell(sender as! UICollectionViewCell) //get index of data for selected row
            
            let s = fetchedResultsController.objectAtIndexPath(indexPath!) as! Set
            secondViewController.isSet = true
            secondViewController.passData = s // get data by index and pass it to second view controller
            
        }
    }

}
