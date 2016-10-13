 //
//  airportCellView.swift
//  AirplaneListApp
//
//  Created by Thomas Woerdeman on 15/09/16.
//  Copyright © 2016 FraTho. All rights reserved.
//

import UIKit

class airportCellView: UITableViewCell {

    
    @IBOutlet var icaoLabel: UILabel!
    @IBOutlet var muniLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
