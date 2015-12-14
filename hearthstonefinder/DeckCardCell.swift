//
//  DeckCardCell.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/12/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit

class DeckCardCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cardCount: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var manaImage: UIImageView!
    @IBOutlet weak var manaCost: UILabel!
    @IBOutlet weak var need: UILabel!
    @IBOutlet weak var dust: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = cardImage.frame
        gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        gradient.startPoint = CGPointMake(0.1, 0.5)
        gradient.endPoint = CGPointMake(1, 0.5)
        
        cardImage.layer.mask = gradient
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
