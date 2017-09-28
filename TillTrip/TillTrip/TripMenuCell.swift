//
//  TripMenuCell.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 28.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class TripMenuCell: UITableViewCell {
	
	var universalConstraints = [NSLayoutConstraint]()
	
	let verticalGap: CGFloat = 10
	let horizontalGap: CGFloat = 15
	
	let destination = UILabel()
	let destinationName = UILabel()
	let dayLeft = UILabel()
	let dayLeftNumber = UILabel()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: "TripMenuCell")
		
		addSubview(destination)
		addSubview(destinationName)
		addSubview(dayLeftNumber)
		addSubview(dayLeft)
		
		configureUniversalConstraints()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	func configureUniversalConstraints() {
		
		destination.translatesAutoresizingMaskIntoConstraints = false
		destinationName.translatesAutoresizingMaskIntoConstraints = false
		dayLeftNumber.translatesAutoresizingMaskIntoConstraints = false
		dayLeft.translatesAutoresizingMaskIntoConstraints = false
		
		//destination Label
		universalConstraints.append(destination.topAnchor.constraint(equalTo: topAnchor, constant: verticalGap))
		universalConstraints.append(destination.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalGap + 10))
		
		//destinationName Label
		universalConstraints.append(destinationName.topAnchor.constraint(equalTo: destination.bottomAnchor, constant: verticalGap))
		universalConstraints.append(destinationName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalGap))
		
		//dayLeftNumber
		universalConstraints.append(dayLeftNumber.topAnchor.constraint(equalTo: destinationName.topAnchor))
		universalConstraints.append(dayLeftNumber.leadingAnchor.constraint(equalTo: destinationName.trailingAnchor, constant: horizontalGap))
		
		//dayLeft Label
		universalConstraints.append(dayLeft.topAnchor.constraint(equalTo: topAnchor, constant: verticalGap))
		universalConstraints.append(dayLeft.centerXAnchor.constraint(equalTo: dayLeftNumber.centerXAnchor))
		
		
		
		
	}

}
