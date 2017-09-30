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
	
	let verticalGap: CGFloat = 5
	let horizontalGap: CGFloat = 15
	
	
	var tripNameLabel = UILabelWithInsets()
	var tripDateLabel = UILabelWithInsets()
	var tripNameTextField = UITextField()
	var tripDateTextField = UITextField()
	var acceptTripButton = UIButton()
	var cancelTripButton = UIButton()
	var imageView = UIImageView()
	
	var universalCoinstrains = [NSLayoutConstraint]()
	var compactVerticalConstraints = [NSLayoutConstraint]()
	var regularVerticalConstraints = [NSLayoutConstraint]()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		print("view will appear searchKey name in Trip: \(searchKey)")
		
	}
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.black
		
		view.addSubview(imageView)
		view.addSubview(tripNameLabel)
		view.addSubview(tripNameTextField)
		view.addSubview(tripDateLabel)
		view.addSubview(tripDateTextField)
		//view.addSubview(acceptTripButton)
		//view.addSubview(cancelTripButton)
		
		
		
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
		
		print("view did load searchKey name in Trip: \(searchKey)")
		
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
		
		configureUniversalConstraints()
		configureCopactConstraints()

		
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
		
		//imageView
		universalCoinstrains.append(imageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: verticalGap))
		universalCoinstrains.append(imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap))
		universalCoinstrains.append(imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap))
		
		//tripName Label
		universalCoinstrains.append(tripNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalGap))
		universalCoinstrains.append(tripNameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor))

		//tripName textField
		universalCoinstrains.append(tripNameTextField.topAnchor.constraint(equalTo: tripNameLabel.bottomAnchor, constant: verticalGap * 2))
		universalCoinstrains.append(tripNameTextField.centerXAnchor.constraint(equalTo: tripNameLabel.centerXAnchor))
		
		//tripDate Label
		universalCoinstrains.append(tripDateLabel.topAnchor.constraint(equalTo: tripNameTextField.bottomAnchor, constant: verticalGap * 2))
		universalCoinstrains.append(tripDateLabel.centerXAnchor.constraint(equalTo: tripNameTextField.centerXAnchor))
		
		//tripDate textField
		universalCoinstrains.append(tripDateTextField.topAnchor.constraint(equalTo: tripDateLabel.bottomAnchor, constant: verticalGap))
		universalCoinstrains.append(tripDateTextField.centerXAnchor.constraint(equalTo: tripDateLabel.centerXAnchor))
		
		NSLayoutConstraint.activate(universalCoinstrains)
	}
	
	func configureCopactConstraints() {
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		tripNameTextField.translatesAutoresizingMaskIntoConstraints = false
		
		let viewHeight = view.frame.size.height
		compactVerticalConstraints.append(imageView.heightAnchor.constraint(equalToConstant: (viewHeight / 5) ))
		compactVerticalConstraints.append(tripNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap))
		compactVerticalConstraints.append(tripNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap))
		compactVerticalConstraints.append(tripDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap * 3))
		compactVerticalConstraints.append(tripDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap * 3))
		NSLayoutConstraint.activate(compactVerticalConstraints)
		
	}
	
	func configureRegularConstraints() {
		let viewHeight = view.frame.size.height
		regularVerticalConstraints.append(imageView.heightAnchor.constraint(equalToConstant: (viewHeight / 3) ))
		regularVerticalConstraints.append(tripNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66))
	}
	
	override func viewDidLayoutSubviews() {
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
	
	@IBAction func addTripButtonTapped(_ sender: UIButton) {
		
		
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
	
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
		
	}

	func createDatePicker() {
		
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
