//
//  CardCell.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 11/30/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
