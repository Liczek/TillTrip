//
//  UILabelWithInsets.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 28.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class UILabelWithInsets: UILabel {

	let horizontalInset: CGFloat = 8
	let verticalInset: CGFloat = 3
	
	override func drawText(in rect: CGRect) {
		let insetValue = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)
		super.drawText(in: UIEdgeInsetsInsetRect(rect, insetValue))
	}
	
	override var intrinsicContentSize: CGSize {
		get {
			var contentSize = super.intrinsicContentSize
			contentSize.height += verticalInset * 2
			contentSize.width += horizontalInset * 2
			return contentSize
		}
	}

}
