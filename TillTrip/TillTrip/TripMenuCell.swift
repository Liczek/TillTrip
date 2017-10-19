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
	var verticalConstraints = [NSLayoutConstraint]()
	var horizontalConstraints = [NSLayoutConstraint]()
	
	let verticalGap: CGFloat = 5
	let horizontalGap: CGFloat = 15
	let bgGap: CGFloat = 2.5
	let bgImageBorderWidth: CGFloat = 5
	let cornerRadius: CGFloat = 25
	let bgBorderAndCornerRadius: CGFloat = 70
	
	var isRotated = false
	
	let bgImage = UIImageView()
	let leftMainImage = UIImageView()
	let rightMainImage = UIImageView()
	let mainImage = UIImageView()
	let destination = UILabelWithInsets()
	let destinationName = UILabelWithInsets()
	let dayLeft = UILabelWithInsets()
	let dayLeftNumber = UILabelWithInsets()
	
	
	var searchKey: String!
	var bgImageName: String!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: "TripMenuCell")
		
		//self.bgBorderAndCornerRadius = (bgImageBorderWidth * 4) + (cornerRadius * 2)
		
		addSubview(bgImage)
		addSubview(leftMainImage)
		addSubview(rightMainImage)
		addSubview(mainImage)
		addSubview(destination)
		addSubview(dayLeft)
		addSubview(destinationName)		
		addSubview(dayLeftNumber)
		
		
		
		configureLabels()
		configureBGImage()
		
		configureUniversalConstraints()
		configureVerticalConstraints()
		configureHorizontalConstraints()
		
		self.backgroundColor = UIColor.clear
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		
		if traitCollection.verticalSizeClass == .compact {
			print("horizontal")
			animateHorizontal()
					} else if traitCollection.verticalSizeClass == .regular {
			print("vertical")
			animateVertical()
			leftMainImage.isHidden = false
			rightMainImage.isHidden = false
		}
	}
	
	func animateHorizontal() {
		print("animate horizontal")
		UIView.animate(withDuration: 5.0, delay: 0.5, animations: {
			//telefon w poziomie
			self.leftMainImage.isHidden = false
			self.rightMainImage.isHidden = false
			NSLayoutConstraint.deactivate(self.horizontalConstraints)
			NSLayoutConstraint.activate(self.verticalConstraints)
			self.layoutIfNeeded()
		})
	}
	func animateVertical() {
		print("animate vertical")
		UIView.animate(withDuration: 5.0, delay: 0.5, animations: {
			//telefon w pionie
			NSLayoutConstraint.deactivate(self.verticalConstraints)
			NSLayoutConstraint.activate(self.horizontalConstraints)
			self.layoutIfNeeded()
			self.leftMainImage.isHidden = true
			self.rightMainImage.isHidden = true
		})
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
		mainImage.translatesAutoresizingMaskIntoConstraints = false
		destination.translatesAutoresizingMaskIntoConstraints = false
		destinationName.translatesAutoresizingMaskIntoConstraints = false
		dayLeftNumber.translatesAutoresizingMaskIntoConstraints = false
		dayLeft.translatesAutoresizingMaskIntoConstraints = false
		leftMainImage.translatesAutoresizingMaskIntoConstraints = false
		rightMainImage.translatesAutoresizingMaskIntoConstraints = false
		
		//bgImage View
		universalConstraints.append(bgImage.topAnchor.constraint(equalTo: topAnchor, constant: bgGap))
		universalConstraints.append(bgImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bgGap))
		universalConstraints.append(bgImage.leadingAnchor.constraint(equalTo: leadingAnchor))
		universalConstraints.append(bgImage.trailingAnchor.constraint(equalTo: trailingAnchor))
		
		//MainImage View
		universalConstraints.append(mainImage.heightAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgImageBorderWidth * 4))
		universalConstraints.append(mainImage.widthAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgImageBorderWidth * 4))
		universalConstraints.append(mainImage.centerXAnchor.constraint(equalTo: bgImage.centerXAnchor))
		universalConstraints.append(mainImage.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor))
		
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
	
	func configureVerticalConstraints() {
		//aktywne jak telefon w poziomie
		
		
		//leftMainImageView
		verticalConstraints.append(leftMainImage.heightAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgBorderAndCornerRadius))
		verticalConstraints.append(leftMainImage.widthAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgBorderAndCornerRadius))
		verticalConstraints.append(leftMainImage.trailingAnchor.constraint(equalTo: bgImage.centerXAnchor, constant: -bgBorderAndCornerRadius * 0.5))
		verticalConstraints.append(leftMainImage.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor))
		
		//rightMainImageView
		verticalConstraints.append(rightMainImage.heightAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgBorderAndCornerRadius))
		verticalConstraints.append(rightMainImage.widthAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgBorderAndCornerRadius))
		verticalConstraints.append(rightMainImage.leadingAnchor.constraint(equalTo: bgImage.centerXAnchor, constant: bgBorderAndCornerRadius * 0.5))
		verticalConstraints.append(rightMainImage.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor))
		
		
		//NSLayoutConstraint.activate(verticalConstraints)
	}
	
	func configureHorizontalConstraints() {
		//aktywna jak telefon jest w pionie
		//leftMainImageView
		horizontalConstraints.append(leftMainImage.heightAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgImageBorderWidth * 4))
		horizontalConstraints.append(leftMainImage.widthAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 0.8, constant: -bgImageBorderWidth * 4))
		horizontalConstraints.append(leftMainImage.centerXAnchor.constraint(equalTo: bgImage.centerXAnchor))
		horizontalConstraints.append(leftMainImage.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor))
		
		//rightMainImageView
		horizontalConstraints.append(rightMainImage.heightAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 1, constant: -bgImageBorderWidth * 4))
		horizontalConstraints.append(rightMainImage.widthAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 0.8, constant: -bgImageBorderWidth * 4))
		horizontalConstraints.append(rightMainImage.centerXAnchor.constraint(equalTo: bgImage.centerXAnchor))
		horizontalConstraints.append(rightMainImage.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor))
		
		
		NSLayoutConstraint.activate(horizontalConstraints)
		
		
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
		bgImage.layer.cornerRadius = cornerRadius
		bgImage.layer.borderWidth = bgImageBorderWidth
		bgImage.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
		
		leftMainImage.image = bgImage.image
		leftMainImage.clipsToBounds = true
		leftMainImage.layer.cornerRadius = cornerRadius
		leftMainImage.layer.borderWidth = bgImageBorderWidth
		leftMainImage.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
		leftMainImage.isHidden = false
		leftMainImage.contentMode = .scaleAspectFill
		
		
		rightMainImage.image = bgImage.image
		rightMainImage.clipsToBounds = true
		rightMainImage.layer.cornerRadius = cornerRadius
		rightMainImage.layer.borderWidth = bgImageBorderWidth
		rightMainImage.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
		rightMainImage.contentMode = .scaleAspectFill
		
		mainImage.clipsToBounds = true
		mainImage.layer.cornerRadius = cornerRadius
		mainImage.layer.borderWidth = bgImageBorderWidth
		mainImage.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
		
		
	}
	
	

}
