//
//  HudView.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 14.10.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class HudView: UIView {

	let background = UIImageView()
	let boxBackground = UIImageView()
	let hudNameLabel = UILabelWithInsets()
	let hudImage = UIImageView()
	let gap: CGFloat = 10
	
	var universalConstraints = [NSLayoutConstraint]()
	
	
	override func willMove(toSuperview newSuperview: UIView?) {
		
		addSubview(background)
		addSubview(boxBackground)
		addSubview(hudNameLabel)
		addSubview(hudImage)
		
		configureUniversalConstraints()
		configureObjects()
		animation()
	}
	
	func configureUniversalConstraints() {
		
		background.translatesAutoresizingMaskIntoConstraints = false
		boxBackground.translatesAutoresizingMaskIntoConstraints = false
		hudNameLabel.translatesAutoresizingMaskIntoConstraints = false
		hudImage.translatesAutoresizingMaskIntoConstraints = false
		
		//Background
		universalConstraints.append(background.topAnchor.constraint(equalTo: topAnchor))
		universalConstraints.append(background.bottomAnchor.constraint(equalTo: bottomAnchor))
		universalConstraints.append(background.leadingAnchor.constraint(equalTo: leadingAnchor))
		universalConstraints.append(background.trailingAnchor.constraint(equalTo: trailingAnchor))

		//Boxbackground
		universalConstraints.append(boxBackground.centerXAnchor.constraint(equalTo: centerXAnchor))
		universalConstraints.append(boxBackground.centerYAnchor.constraint(equalTo: centerYAnchor))
		universalConstraints.append(boxBackground.widthAnchor.constraint(equalToConstant: 250))
		universalConstraints.append(boxBackground.heightAnchor.constraint(equalToConstant: 250))
		
		//Label
		universalConstraints.append(hudNameLabel.topAnchor.constraint(equalTo: boxBackground.topAnchor, constant: gap))
		universalConstraints.append(hudNameLabel.leadingAnchor.constraint(equalTo: boxBackground.leadingAnchor, constant: gap))
		universalConstraints.append(hudNameLabel.trailingAnchor.constraint(equalTo: boxBackground.trailingAnchor, constant: -gap))
		hudNameLabel.setContentCompressionResistancePriority(1000, for: UILayoutConstraintAxis.vertical)
		
		//Image
		universalConstraints.append(hudImage.topAnchor.constraint(greaterThanOrEqualTo: hudNameLabel.bottomAnchor, constant: gap))
		universalConstraints.append(hudImage.leadingAnchor.constraint(equalTo: boxBackground.leadingAnchor, constant: gap))
		universalConstraints.append(hudImage.trailingAnchor.constraint(equalTo: boxBackground.trailingAnchor, constant: -gap))
		universalConstraints.append(hudImage.bottomAnchor.constraint(equalTo: boxBackground.bottomAnchor, constant: -gap))
		
		
		NSLayoutConstraint.activate(universalConstraints)
		
	}
	
	func configureObjects() {
		
		
		//Background
		background.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		//background.image = UIImage(named: "thai1")
		
		
		//BoxBackground
		boxBackground.backgroundColor = UIColor.black.withAlphaComponent(0.4)
		boxBackground.layer.borderWidth = 2
		boxBackground.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
		boxBackground.clipsToBounds = true
		boxBackground.layer.cornerRadius = 10
		
		//hudNameLabel
		hudNameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
		hudNameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
		hudNameLabel.layer.borderWidth = 1
		hudNameLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
		hudNameLabel.clipsToBounds = true
		hudNameLabel.textColor = UIColor.white.withAlphaComponent(0.4)
		hudNameLabel.layer.cornerRadius = 10
		hudNameLabel.textAlignment = .center
		hudNameLabel.sizeToFit()
		
		//hudImage
		hudImage.clipsToBounds = true
		hudImage.contentMode = .scaleAspectFill
		hudImage.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
		hudImage.layer.borderWidth = 0.5
		hudImage.layer.cornerRadius = 10
		hudImage.alpha = 0.8
		
	}
	
	func animation() {
		alpha = 0
		transform = CGAffineTransform(scaleX: 5, y: 5)
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: [], animations: {
			self.alpha = 1
			self.transform = CGAffineTransform.identity},
		               completion: nil)
		
		UIView.animate(withDuration: 1, delay: 0.8, animations: {
			self.alpha = 0
			self.transform = CGAffineTransform.identity
			
		})
	}
	
	
	
}
