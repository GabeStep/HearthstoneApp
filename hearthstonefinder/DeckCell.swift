//
//  DeckCell.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/6/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit

class DeckCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var dust: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = heroImage.frame
        gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        gradient.startPoint = CGPointMake(0.1, 0.5)
        gradient.endPoint = CGPointMake(1, 0.5)
        heroImage.layer.mask = gradient
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
