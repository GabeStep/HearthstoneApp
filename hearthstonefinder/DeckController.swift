//
//  DeckController.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/12/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData
import Charts
import SafariServices

class DeckController: UITableViewController , NSFetchedResultsControllerDelegate {
    var passData: String?;
    var deck:Deck?;
    var cards: [(Int,Card)] = []
    @IBOutlet weak var totalDust: UILabel!
    @IBOutlet weak var subView: UIView!
    var cost: [String]!
    var manaC: [Int]?
    
    // Managed Object Context
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func openDeckSafariVC(sender: AnyObject) {
        let svc = SFSafariViewController(URL: NSURL(string: (self.deck?.link!)!)!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    // Controller for Fetching Sets
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cost = ["0","1","2","3","4","5","6","7","8","9","10+"]
        // Need to pass in an instance of the Deck class to call manaCurve which will create the array for us that we'll pass into setChart
        
        //let manaC = manaCurve()
        manaC = [Int](count: 11, repeatedValue: 0);
        
        fetchedResultsController = getFetchedResultController()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
        
        if let d = fetchedResultsController.fetchedObjects![0] as? Deck{
            deck = d
            manaC = d.manaCurve()
            self.title = d.name
        }
        
        cards = deck!.cardArray()
        
        self.tableView.reloadData()
    }
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Deck")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", passData!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func setChart(dataPoints: [String], values: [Int], manaCurve: LineChartView) {
        manaCurve.noDataText = "Failure to Calculate ManaCurve."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let ChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Mana Cost")
        let ChartData = LineChartData(xVals: cost, dataSet: ChartDataSet)
        
        manaCurve.data = ChartData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(cards.count)")
        return cards.count
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.item == 0{
            return 300
        } else {
            return  44.0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.item == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! DeckHeaderCell
            self.setChart(cost, values: manaC!, manaCurve: cell.chart)
            let dust = deck?.dust!
            cell.dustcost.text = "\(dust!)"
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DeckCardCell
        
            let c = cards[indexPath.item - 1];
            // Configure the cell...
        
            cell.cardImage.kf_setImageWithURL(NSURL(string: c.1.img!)!);
            cell.cardImage.alpha = 0.6
            cell.cardImage.layer.contentsRect = CGRectMake(0.25, 0.25, 0.50, 0.1);
        
            cell.name.text = c.1.name!
            var cNeed = c.0 - (c.1.count?.integerValue)!
        
            if(c.1.count?.integerValue >= c.0){
                cNeed = 0
                cell.contentView.backgroundColor = UIColor.lightGrayColor()
                cell.need.text = "0"
            }else{
                cell.contentView.backgroundColor = UIColor.clearColor()
                cell.need.text = "\(cNeed)"
            }
        
            cell.dust.text = "\((cNeed * (c.1.dustCost()?.integerValue)!))"
            cell.cardCount.text = "\(c.0)"
            cell.manaCost.text = "\(c.1.cost!)"
            
            return cell
        }
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "cardShow"{
            let secondViewController : CardViewController = segue.destinationViewController as! CardViewController
            
            let index = (self.tableView.indexPathForSelectedRow?.item)! - 1//get index of data for selected row
            let c = cards[index].1
            
            secondViewController.passData = c.img // get data by index and pass it to second view controller
            
        }
    }
    

}
