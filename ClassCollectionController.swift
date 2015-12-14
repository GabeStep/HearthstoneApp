//
//  ClassCollectionController.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/14/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "Cell"

class ClassCollectionController: UICollectionViewController , NSFetchedResultsControllerDelegate {
    
    // Managed Object Context
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Controller for Fetching Sets
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "boardBackground.jpg")!)

        // Do any additional setup after loading the view.
        
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
        let fetchRequest = NSFetchRequest(entityName: "Class")
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ClassCollectionCell
        
        let c = fetchedResultsController.objectAtIndexPath(indexPath) as! Class
        
        cell.name.text = c.name
        cell.classImage.kf_setImageWithURL(NSURL(string: c.image!)!)
        cell.classImage.layer.contentsRect = CGRectMake(0.36, 0.15, 0.30, 0.35);
        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView!.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "passClass"{
            let secondViewController : MyCardsController = segue.destinationViewController as! MyCardsController
            
            let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell) //get index of data for selected row
            
            let c = fetchedResultsController.objectAtIndexPath(indexPath!) as! Class
            secondViewController.isClass = true
            secondViewController.passData = c // get data by index and pass it to second view controller
            
        }
    }

}
