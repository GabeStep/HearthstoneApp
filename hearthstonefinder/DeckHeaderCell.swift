//
//  DeckHeaderCell.swift
//  hearthstonefinder
//
//  Created by Steven Hawley on 12/13/15.
//  Copyright © 2015 Yosemite. All rights reserved.
//

import UIKit
import Charts

class DeckHeaderCell: UITableViewCell {
    
    @IBOutlet weak var chart: LineChartView!
    
    @IBOutlet weak var dustcost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
