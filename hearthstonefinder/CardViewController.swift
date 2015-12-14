//
//  CardViewController.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/11/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import CoreData
import Kingfisher

class CardViewController: UIViewController {

    var passData: String?;
    
    @IBOutlet weak var cardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "boardBackground.jpg")!)
        cardImage.kf_setImageWithURL(NSURL(string: passData!)!);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
