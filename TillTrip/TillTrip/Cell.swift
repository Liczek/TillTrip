//
//  Cell.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 14.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

	@IBOutlet weak var tripNameLabel: UILabel!
	@IBOutlet weak var daysLeftLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
		
		tripNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameLabel.textColor = UIColor.white
		
		daysLeftLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		daysLeftLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
