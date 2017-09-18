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
	@IBOutlet weak var bgImage: UIImageView!
	@IBOutlet weak var labelsBG: UIImageView!
	@IBOutlet weak var destinationLabel: UILabel!
	@IBOutlet weak var ddayLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
		
		tripNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameLabel.textColor = UIColor.white
		
		daysLeftLabel.font = UIFont.preferredFont(forTextStyle: .headline)
		daysLeftLabel.textColor = UIColor.white
		
		bgImage.clipsToBounds = true
		bgImage.layer.cornerRadius = 10
		
		labelsBG.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
		labelsBG.layer.cornerRadius = 10
		
		destinationLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		destinationLabel.clipsToBounds = true
		destinationLabel.layer.cornerRadius = 10
		destinationLabel.textColor = UIColor.white
		destinationLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
		destinationLabel.textAlignment = .center
		
		ddayLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		ddayLabel.clipsToBounds = true
		ddayLabel.layer.cornerRadius = 10
		ddayLabel.textColor = UIColor.white
		ddayLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.75)
		ddayLabel.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
