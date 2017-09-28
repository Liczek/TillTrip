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
	
	let verticalGap: CGFloat = 5
	let horizontalGap: CGFloat = 15
	let bgGap: CGFloat = 2.5
	let bgImageBorderWidth: CGFloat = 5
	
	let bgImage = UIImageView()
	let destination = UILabelWithInsets()
	let destinationName = UILabelWithInsets()
	let dayLeft = UILabelWithInsets()
	let dayLeftNumber = UILabelWithInsets()
	
	var searchKey: String!
	var bgImageName: String!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: "TripMenuCell")
		
		addSubview(bgImage)
		addSubview(destination)
		addSubview(dayLeft)
		addSubview(destinationName)		
		addSubview(dayLeftNumber)
		
		
		configureLabels()
		configureBGImage()
		
		configureUniversalConstraints()
		
		self.backgroundColor = UIColor.clear
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
		
		bgImage.translatesAutoresizingMaskIntoConstraints = false
		destination.translatesAutoresizingMaskIntoConstraints = false
		destinationName.translatesAutoresizingMaskIntoConstraints = false
		dayLeftNumber.translatesAutoresizingMaskIntoConstraints = false
		dayLeft.translatesAutoresizingMaskIntoConstraints = false
		
		//bgImage View
		universalConstraints.append(bgImage.topAnchor.constraint(equalTo: topAnchor, constant: bgGap))
		universalConstraints.append(bgImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bgGap))
		universalConstraints.append(bgImage.leadingAnchor.constraint(equalTo: leadingAnchor))
		universalConstraints.append(bgImage.trailingAnchor.constraint(equalTo: trailingAnchor))
		
		//destination Label
		universalConstraints.append(destination.topAnchor.constraint(equalTo: bgImage.topAnchor, constant: verticalGap + bgImageBorderWidth))
		universalConstraints.append(destination.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalGap))
		
		//dayLeft Label
		universalConstraints.append(dayLeft.topAnchor.constraint(equalTo: destination.topAnchor))
		universalConstraints.append(dayLeft.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalGap))
		
		//destinationName Label
		universalConstraints.append(destinationName.topAnchor.constraint(equalTo: destination.bottomAnchor, constant: verticalGap))
		universalConstraints.append(destinationName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalGap))
		universalConstraints.append(destinationName.trailingAnchor.constraint(lessThanOrEqualTo: dayLeft.leadingAnchor, constant: -horizontalGap))
		
		//dayLeftNumber
		universalConstraints.append(dayLeftNumber.topAnchor.constraint(equalTo: destinationName.topAnchor))
		universalConstraints.append(dayLeftNumber.centerXAnchor.constraint(equalTo: dayLeft.centerXAnchor))
		
		
		NSLayoutConstraint.activate(universalConstraints)
	}
	
	func configureLabels() {
		
		dayLeft.text = "Days left"
		destination.text = "Destination"
		
		let labels = [destination, destinationName, dayLeftNumber, dayLeft]
		for label in labels {
			label.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
			label.font = UIFont.preferredFont(forTextStyle: .headline)
			label.clipsToBounds = true
			label.layer.cornerRadius = 10
			label.textColor = UIColor.white.withAlphaComponent(0.85)
			label.layer.borderWidth = 0.5
			label.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
		}
		destinationName.lineBreakMode = .byClipping
		destinationName.numberOfLines = 2
		dayLeftNumber.font = UIFont.preferredFont(forTextStyle: .title1)
		
	}
	
	func configureBGImage() {
		bgImage.clipsToBounds = true
		bgImage.layer.cornerRadius = 25
		bgImage.layer.borderWidth = bgImageBorderWidth
		bgImage.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
	}

}
