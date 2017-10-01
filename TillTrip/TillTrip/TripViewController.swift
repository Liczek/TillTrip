//
//  TripViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 19.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit
import CoreData

class TripViewController: UIViewController, UITextFieldDelegate {
	
	var datePicker = UIDatePicker()
	var managedContext: NSManagedObjectContext!
	var searchKey: String!
	var pickedDate: Date!
	var trips = [Trip]()
	var imageName: String!
	
	var verticalGap: CGFloat = 5
	var horizontalGap: CGFloat = 15
	
	
	var tripNameLabel = UILabelWithInsets()
	var tripDateLabel = UILabelWithInsets()
	var tripNameTextField = UITextField()
	var tripDateTextField = UITextField()
	var acceptTripButton = UIButton()
	var cancelTripButton = UIButton()
	var imageView = UIImageView()
	var viewHeight = CGFloat()
	
	var universalCoinstrains = [NSLayoutConstraint]()
	var compactVerticalConstraints = [NSLayoutConstraint]()
	var regularVerticalConstraints = [NSLayoutConstraint]()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.black
		
		view.addSubview(imageView)
		view.addSubview(tripNameLabel)
		view.addSubview(tripNameTextField)
		view.addSubview(tripDateLabel)
		view.addSubview(tripDateTextField)
		view.addSubview(acceptTripButton)
		view.addSubview(cancelTripButton)
		
		configureUniversalConstraints()
		
		
		if traitCollection.verticalSizeClass == .compact {
			configureCompactConstraints()
			NSLayoutConstraint.activate(compactVerticalConstraints)
		} else if traitCollection.verticalSizeClass == .regular {
			configureRegularConstraints()

			NSLayoutConstraint.activate(regularVerticalConstraints)
		}
		
		imageView.layer.cornerRadius = 10
		if imageName == nil {
			imageView.image = UIImage(named: "thai8")
		} else {
		imageView.image = UIImage(named: imageName)
		}
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleToFill
		
		configureItems()
		
		tripNameTextField.delegate = self
		
		acceptTripButton.addTarget(self, action: #selector(addTripButtonTapped(_:)), for: .touchUpInside)
		cancelTripButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
		
		if searchKey != nil {
			
			acceptTripButton.setTitle("Accept Changes", for: .normal)
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			managedContext = appDelegate.persistentContainer.viewContext
			
			let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
			fetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchKey!)
			
			do {
				trips = try managedContext.fetch(fetchRequest)
				
				guard let tripToEdit = trips.first else {return}
				print("number of trips\(String(describing: tripToEdit.name))")
				tripNameTextField.text = tripToEdit.name
				tripDateTextField.text = dateConverterToString(from: tripToEdit.date! as Date)
				pickedDate = tripToEdit.date! as Date
				
			} catch let error as NSError {
				print("Could Not Load/Create Trip \(error), \(error.userInfo)")
			}
			
		} else {
			
			acceptTripButton.setTitle("Add Trip", for: .normal)
			
		}
		createDatePicker()
		
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if traitCollection.verticalSizeClass == .regular {
			configureRegularConstraints()
			NSLayoutConstraint.deactivate(compactVerticalConstraints)
			NSLayoutConstraint.activate(regularVerticalConstraints)
		} else if traitCollection.verticalSizeClass == .compact {
			configureCompactConstraints()
			NSLayoutConstraint.deactivate(regularVerticalConstraints)
			NSLayoutConstraint.activate(compactVerticalConstraints)
		}
	}
	
	func configureItems() {
		
		tripNameLabel.text = "Trip name"
		tripDateLabel.text = "Date of trip"
		
		let labels = [tripNameLabel, tripDateLabel]
		for label in labels {
			label.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
			label.font = UIFont.preferredFont(forTextStyle: .headline)
			label.clipsToBounds = true
			label.layer.cornerRadius = 10
			label.textColor = UIColor.white.withAlphaComponent(0.85)
			label.layer.borderWidth = 0.5
			label.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
		}
		
		
		tripNameTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameTextField.backgroundColor = UIColor.white
		tripNameTextField.textColor = UIColor.black
		tripNameTextField.autocapitalizationType = .sentences
		tripNameTextField.clearButtonMode = .whileEditing
		tripNameTextField.placeholder = "Set trip name"
		tripNameTextField.textAlignment = .center
		tripNameTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameTextField.borderStyle = .roundedRect
		
		tripDateTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripDateTextField.backgroundColor = UIColor.white
		tripDateTextField.textColor = UIColor.black
		tripDateTextField.autocapitalizationType = .sentences
		tripDateTextField.clearButtonMode = .whileEditing
		tripDateTextField.placeholder = "Trip date"
		tripDateTextField.textAlignment = .center
		tripDateTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripDateTextField.borderStyle = .roundedRect
		
		acceptTripButton.clipsToBounds = true
		acceptTripButton.layer.cornerRadius = 10
		acceptTripButton.backgroundColor = UIColor.darkGray
		acceptTripButton.setTitleColor(UIColor.white.withAlphaComponent(0.75), for: .normal)
		acceptTripButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
		
		cancelTripButton.setTitle("Cancel", for: .normal)
		cancelTripButton.clipsToBounds = true
		cancelTripButton.layer.cornerRadius = 10
		cancelTripButton.backgroundColor = UIColor.darkGray
		cancelTripButton.setTitleColor(UIColor.white.withAlphaComponent(0.30), for: .normal)
		cancelTripButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		
	}
	
	func configureUniversalConstraints() {
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		tripNameLabel.translatesAutoresizingMaskIntoConstraints = false
		tripNameLabel.translatesAutoresizingMaskIntoConstraints = false
		tripNameTextField.translatesAutoresizingMaskIntoConstraints = false
		tripDateLabel.translatesAutoresizingMaskIntoConstraints = false
		tripDateTextField.translatesAutoresizingMaskIntoConstraints = false
		acceptTripButton.translatesAutoresizingMaskIntoConstraints = false
		cancelTripButton.translatesAutoresizingMaskIntoConstraints = false
		
		//imageView
		universalCoinstrains.append(imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: verticalGap))
		universalCoinstrains.append(imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap))
		universalCoinstrains.append(imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap))
		
		//tripName Label
		universalCoinstrains.append(tripNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalGap))
		universalCoinstrains.append(tripNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))

		//tripName textField
		universalCoinstrains.append(tripNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor))
		
		//tripDate Label
		universalCoinstrains.append(tripDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
		
		//tripDate textField
		universalCoinstrains.append(tripDateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor))

		//AcceptButton
		universalCoinstrains.append(acceptTripButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
		
		//CancelButton
		universalCoinstrains.append(cancelTripButton.topAnchor.constraint(equalTo: acceptTripButton.topAnchor))
		universalCoinstrains.append(cancelTripButton.trailingAnchor.constraint(equalTo: acceptTripButton.leadingAnchor , constant: -horizontalGap))
		
		NSLayoutConstraint.activate(universalCoinstrains)
	}
	
	func configureRegularConstraints() {
		viewHeight = view.frame.height
		print("\ncompact: \(viewHeight)\n")
		regularVerticalConstraints.append(imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2))
		regularVerticalConstraints.append(tripNameTextField.topAnchor.constraint(equalTo: tripNameLabel.bottomAnchor, constant: verticalGap))
		regularVerticalConstraints.append(tripNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap))
		regularVerticalConstraints.append(tripNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap))
		regularVerticalConstraints.append(tripDateLabel.topAnchor.constraint(equalTo: tripNameTextField.bottomAnchor, constant: verticalGap * 5))
		regularVerticalConstraints.append(tripDateTextField.topAnchor.constraint(equalTo: tripDateLabel.bottomAnchor, constant: verticalGap))
		regularVerticalConstraints.append(tripDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap * 3))
		regularVerticalConstraints.append(tripDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap * 3))
		regularVerticalConstraints.append(acceptTripButton.topAnchor.constraint(equalTo: tripDateTextField.bottomAnchor, constant: verticalGap * 5))
		
	}
	
	func configureCompactConstraints() {
		viewHeight = view.frame.height
		print("\nregular: \(viewHeight)\n")
		compactVerticalConstraints.append(imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3333333333))

		compactVerticalConstraints.append(tripNameTextField.topAnchor.constraint(equalTo: tripNameLabel.bottomAnchor, constant: verticalGap))
		compactVerticalConstraints.append(tripNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66))
		compactVerticalConstraints.append(tripDateLabel.topAnchor.constraint(equalTo: tripNameTextField.bottomAnchor, constant: verticalGap * 3))
		compactVerticalConstraints.append(tripDateTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5))
		compactVerticalConstraints.append(tripDateTextField.topAnchor.constraint(equalTo: tripDateLabel.bottomAnchor, constant: verticalGap))
		compactVerticalConstraints.append(acceptTripButton.topAnchor.constraint(equalTo: tripDateTextField.bottomAnchor, constant: verticalGap * 3))
	}
	
	
	override func viewDidLayoutSubviews() {
		setImageGradientBorders()
	}
	
	func setImageGradientBorders() {
		imageView.layer.sublayers = nil
		
		let topGradient: CAGradientLayer = CAGradientLayer()
		topGradient.frame = imageView.layer.bounds
		topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
		topGradient.locations = [0.0, 0.2]
		imageView.layer.addSublayer(topGradient)
		
		let leftGradient: CAGradientLayer = CAGradientLayer()
		leftGradient.frame = imageView.bounds
		leftGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
		leftGradient.locations = [0.0, 0.2]
		leftGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		leftGradient.endPoint = CGPoint(x: 0.2, y: 0.5)
		imageView.layer.addSublayer(leftGradient)
		
		let bottomGradient: CAGradientLayer = CAGradientLayer()
		bottomGradient.frame = imageView.bounds
		bottomGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		bottomGradient.locations = [0.8, 1.0]
		imageView.layer.addSublayer(bottomGradient)
		
		let rightGradient: CAGradientLayer = CAGradientLayer()
		rightGradient.frame = imageView.bounds
		rightGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		rightGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		rightGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
		rightGradient.locations = [0.95, 1.0]
		imageView.layer.addSublayer(rightGradient)
	}
	
	func addTripButtonTapped(_ sender: UIButton) {
		
		
		if pickedDate == nil && tripNameTextField.text == "" {
			self.navigationController?.popViewController(animated: true)
		} else {
			if pickedDate == nil {
				pickedDate = Date()
			}
			if tripNameTextField.text == "" {
				tripNameTextField.text = "No Destination Name"
			}
			
			view.resignFirstResponder()
			
			doneDatePicking()
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			managedContext = appDelegate.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
			if searchKey != nil {
				fetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchKey)
				
				do {
					trips = try managedContext.fetch(fetchRequest)
				} catch let error as NSError {
					print("Could Not Fetch For New Trip\(error), \(error.userInfo)")
				}
				
				guard let editedTrip = trips.first else {return}
				editedTrip.name = tripNameTextField.text
				editedTrip.date = pickedDate as NSDate
				
			}else {
				
				let entity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
				let newTrip = NSManagedObject(entity: entity, insertInto: managedContext) as! Trip
				
				addSearchKey()
				
				newTrip.name = tripNameTextField.text
				newTrip.date = pickedDate as NSDate?
				newTrip.searchKey = self.searchKey
			}
			do {
				try managedContext.save()
			} catch let error as NSError {
				print("Could Not Save New Trip \(error), \(error.userInfo)")
			}
			
			self.navigationController?.popViewController(animated: true)
		}
	}
	
	func cancelButtonTapped(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
		
	}

	func createDatePicker() {
		
		datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 162))
		datePicker.datePickerMode = .date
		datePicker.backgroundColor = UIColor.black
		datePicker.setValue(UIColor.white, forKey: "textColor")
		
		if pickedDate != nil {
		datePicker.setDate(pickedDate, animated: true)
		}
		
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		toolBar.barStyle = .default
		toolBar.barTintColor = UIColor.black
		toolBar.tintColor = UIColor.white
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicking))
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelDatePicking))
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
		toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
		tripDateTextField.inputAccessoryView = toolBar
		tripDateTextField.inputView = datePicker
	}
	
	func doneDatePicking() {
		
		pickedDate = datePicker.date
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .full
		dateFormatter.dateFormat = "dd MMMM YYYY"
		let reformatedDate = dateFormatter.string(from: pickedDate)
		tripDateTextField.text = "\(reformatedDate)"
		self.view.endEditing(true)
	}
	
	func cancelDatePicking() {
		tripDateTextField.resignFirstResponder()
	}
	
	func dateConverterToString(from date: Date) -> String{
		
		let pickedDate = date
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .full
		dateFormatter.dateFormat = "dd MMMM YYYY"
		let reformatedDate = dateFormatter.string(from: pickedDate as Date)
		return reformatedDate
	}
	
	func addSearchKey() {
		let uniqueID = UUID().uuidString
		searchKey = uniqueID
	}
	
	func textFieldShouldReturn(_ tripNameTextField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	
	
	

	
}
