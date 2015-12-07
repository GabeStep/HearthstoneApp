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
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
