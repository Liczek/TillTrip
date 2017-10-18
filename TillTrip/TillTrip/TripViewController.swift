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
	var trips: [Trip] = []
	var trip: Trip!
	var imageName: String!
	var image: FullRes!
	
	var bgImages: [FullRes] = []
	
	var verticalGap: CGFloat = 5
	var horizontalGap: CGFloat = 15
	
	
	var tripNameLabel = UILabelWithInsets()
	var tripDateLabel = UILabelWithInsets()
	var setPhotoLabel = UILabel()
	var tripNameTextField = UITextField()
	var tripDateTextField = UITextField()
	var acceptTripButton = UIButton()
	var cancelTripButton = UIButton()
	var imageView = UIImageView()
	var imageSwitch = UISwitch()
	var viewHeight = CGFloat()
	
	var universalCoinstrains = [NSLayoutConstraint]()
	var compactVerticalConstraints = [NSLayoutConstraint]()
	var regularVerticalConstraints = [NSLayoutConstraint]()
	
	var hud = HudView()
	var hudLayoutConstraints = [NSLayoutConstraint]()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if searchKey != nil {
			
			acceptTripButton.setTitle("Accept Changes", for: .normal)
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			managedContext = appDelegate.persistentContainer.viewContext
			
			let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
			fetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchKey!)
			
			do {
				trips = try managedContext.fetch(fetchRequest)
				
				guard let tripToEdit = trips.first else {return}
				tripNameTextField.text = tripToEdit.name
				tripDateTextField.text = dateConverterToString(from: tripToEdit.date! as Date)
				pickedDate = tripToEdit.date! as Date
				imageName = tripToEdit.imageName
			} catch let error as NSError {
				print("Could Not Load/Create Trip \(error), \(error.userInfo)")
			}
			
		} else {
			
			acceptTripButton.setTitle("Add Trip", for: .normal)
			
		}
		tripImageConfiguration()
		print(imageName)
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
		view.addSubview(imageSwitch)
		view.addSubview(setPhotoLabel)
		
		configureUniversalConstraints()
		
		if traitCollection.verticalSizeClass == .compact {
			configureCompactConstraints()
			NSLayoutConstraint.activate(compactVerticalConstraints)
		} else if traitCollection.verticalSizeClass == .regular {
			configureRegularConstraints()
			NSLayoutConstraint.activate(regularVerticalConstraints)
		}
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		
		imageView.layer.cornerRadius = 10
		
		tripImageConfiguration()
		
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
		
		imageSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)
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
		
		let labels = [tripNameLabel, tripDateLabel, setPhotoLabel]
		for label in labels {
			label.backgroundColor = UIColor.darkGray.withAlphaComponent(0.85)
			label.font = UIFont.preferredFont(forTextStyle: .headline)
			label.clipsToBounds = true
			label.layer.cornerRadius = 10
			label.textColor = UIColor.white.withAlphaComponent(0.85)
			label.layer.borderWidth = 0.5
			label.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
		}
		
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleToFill
		
		tripNameLabel.text = "Trip name"
		tripDateLabel.text = "Date of trip"
		setPhotoLabel.text = "Set Photo"
		setPhotoLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
		setPhotoLabel.backgroundColor = UIColor.clear
		
		tripNameTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameTextField.backgroundColor = UIColor.white
		tripNameTextField.textColor = UIColor.black
		tripNameTextField.autocapitalizationType = .sentences
		tripNameTextField.clearButtonMode = .whileEditing
		tripNameTextField.placeholder = "Set trip name"
		tripNameTextField.textAlignment = .center
		tripNameTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameTextField.borderStyle = .roundedRect
		tripNameTextField.autocorrectionType = .no
		tripNameTextField.keyboardAppearance = .dark
		
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
		acceptTripButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
		
		cancelTripButton.setTitle("Cancel", for: .normal)
		cancelTripButton.clipsToBounds = true
		cancelTripButton.layer.cornerRadius = 10
		cancelTripButton.backgroundColor = UIColor.darkGray
		cancelTripButton.setTitleColor(UIColor.white.withAlphaComponent(0.50), for: .normal)
		cancelTripButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
		cancelTripButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
		
		imageSwitch.tintColor = UIColor.darkGray
		imageSwitch.onTintColor = UIColor.white
		imageSwitch.thumbTintColor = UIColor.lightGray
		
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
		imageSwitch.translatesAutoresizingMaskIntoConstraints = false
		setPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
		
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
		//universalCoinstrains.append(cancelTripButton.topAnchor.constraint(equalTo: acceptTripButton.topAnchor))
		universalCoinstrains.append(cancelTripButton.centerYAnchor.constraint(equalTo: acceptTripButton.centerYAnchor))
		universalCoinstrains.append(cancelTripButton.trailingAnchor.constraint(equalTo: acceptTripButton.leadingAnchor , constant: -horizontalGap))
		
		//Switch
		universalCoinstrains.append(imageSwitch.centerYAnchor.constraint(equalTo: acceptTripButton.centerYAnchor))
		universalCoinstrains.append(imageSwitch.leadingAnchor.constraint(equalTo: acceptTripButton.trailingAnchor, constant: horizontalGap))
		
		//SetPhotoLabel
		universalCoinstrains.append(setPhotoLabel.topAnchor.constraint(equalTo: imageSwitch.bottomAnchor, constant: 2))
		universalCoinstrains.append(setPhotoLabel.centerXAnchor.constraint(equalTo: imageSwitch.centerXAnchor))
		
		NSLayoutConstraint.activate(universalCoinstrains)
	}
	
	func configureRegularConstraints() {
		viewHeight = view.frame.height
		
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
				
			} else {
				
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
//MARK: ALERTS
	
	func switchChanged(imageSwitch: UISwitch) {
		let value = imageSwitch.isOn
		if value == true {
			
			if pickedDate == nil && tripNameTextField.text == "" {
				imageSwitchIsOff()
				ifTripInformationAreEmptyAlert()
			} else {
			 guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
				managedContext = appDelegate.persistentContainer.viewContext
				
				if searchKey == nil {
					alertSaveTripBecauseOfSetImage()
					
				} else {
					let alert = UIAlertController(title: "Do you wanna set image for this Trip?", message: nil, preferredStyle: .alert)
					let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
						self.performSegue(withIdentifier: "setPhoto", sender: nil)
					})
					let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
						imageSwitch.isOn = false})
					
					alert.addAction(yesAction)
					alert.addAction(noAction)
					
					alert.view.tintColor = UIColor.black
					
					present(alert, animated: true, completion: nil)
				}
			}
		} else {
			let alert = UIAlertController(title: nil, message: "What you wanna to do with current Trip photo?", preferredStyle: .alert)
			let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
				
				guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
				self.managedContext = appDelegate.persistentContainer.viewContext
				
				let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
				fetchRequest.predicate = NSPredicate(format: "searchKey == %@", self.searchKey!)
				
				do {
					self.trips = try self.managedContext.fetch(fetchRequest)
					
					guard let tripToEdit = self.trips.first else {return}
					self.trip = tripToEdit
					
					self.hudDeletePhoto()
					
					tripToEdit.imageName = nil
					tripToEdit.imageData = nil
					
				} catch let error as NSError {
					print("Could Not Load/Create Trip \(error), \(error.userInfo)")
				}
				
				do {
					try self.managedContext.save()
				} catch let error as NSError {
					print("Could Not Save trip after Deleting Image \(error), \(error.userInfo)")
				}
				
				self.dismiss(animated: true, completion: nil)
			})
			
			let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
				imageSwitch.isOn = true})
			
			let changeAction = UIAlertAction(title: "Change", style: .default, handler: { (action) in
				self.performSegue(withIdentifier: "setPhoto", sender: nil)
			})
			
			alert.addAction(changeAction)
			alert.addAction(cancelAction)
			alert.addAction(deleteAction)
			
			alert.view.tintColor = UIColor.black
			
			present(alert, animated: true, completion: nil)
			print("Switch is Off")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "setPhoto" {
			let controller = segue.destination as! GalleryViewController
			controller.isEditingPhoto = true
			controller.searchKeyForSelectedTrip = searchKey
		}
	}
	
	func tripImageConfiguration() {
		if imageName == nil {
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			let managedContext = appDelegate.persistentContainer.viewContext
			let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
			
			do {
				bgImages = try managedContext.fetch(fetchRequest)
			} catch let error as NSError {
				print("Could Not Fetch FullRes \(error), \(error.userInfo)")
			}
			
			let maxIndex = bgImages.count
			let randomImageIndex = arc4random_uniform(UInt32(maxIndex))
			image = bgImages[Int(randomImageIndex)]
			if image.imageData == nil {
			imageView.image = UIImage(named: image.imageName!)
			print(image.imageName!)
			} else {
				imageView.image = UIImage(data: image.imageData! as Data)
			}
		} else {
			
			let tripsFetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
			tripsFetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchKey!)
			
			do {
				let fetchedTrips = try managedContext.fetch(tripsFetchRequest)
				trip = fetchedTrips.first!
			} catch let error as NSError {
				print("Could Not Fetch Edited Trip \(error), \(error.userInfo)")
			}
			
			if trip.imageData != nil{
				let tripImageData = trip.imageData! as Data
				imageView.image = UIImage(data: tripImageData)
				imageSwitch.isOn = true
			} else if trip.imageName != nil {
				let tripImageName = trip.imageName! as String
				imageView.image = UIImage(named: tripImageName)
				imageSwitch.isOn = true
			} else {
				
				let imagesFetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
				imagesFetchRequest.predicate = NSPredicate(format: "imageName == %@", imageName!)
				
				do {
					let fetchedImages = try managedContext.fetch(imagesFetchRequest)
					image = fetchedImages.first!
				} catch let error as NSError {
					print("Could Not Load/Create Trip \(error), \(error.userInfo)")
				}
				
				if image.imageData != nil {
					let editedTripImageData: Data = image.imageData! as Data
					imageView.image = UIImage(data: editedTripImageData)
					imageSwitch.isOn = false
				} else {
					imageView.image = UIImage(named: imageName)
					imageSwitch.isOn = false
				}
			}
		}
	}
	
	func hudDeletePhoto() {
		hud.hudNameLabel.text = "REMOVED"
		let selectedImageData = trip.imageData
		let selectedImageName = trip.imageName
		if selectedImageData != nil {
			hud.hudImage.image = UIImage(data: selectedImageData! as Data)
		} else {
			hud.hudImage.image = UIImage(named: selectedImageName!)
		}
		
		showHUD()
		
		
		let when = DispatchTime.now() + 1.8
		DispatchQueue.main.asyncAfter(deadline: when){
			// your code with delay
			self.hud.removeFromSuperview()
		}

	
		}
	
	func showHUD() {
		
		view.addSubview(hud)
		hud.translatesAutoresizingMaskIntoConstraints = false
		hudLayoutConstraints.append(hud.topAnchor.constraint(equalTo: view.topAnchor))
		hudLayoutConstraints.append(hud.bottomAnchor.constraint(equalTo: view.bottomAnchor))
		hudLayoutConstraints.append(hud.leadingAnchor.constraint(equalTo: view.leadingAnchor))
		hudLayoutConstraints.append(hud.trailingAnchor.constraint(equalTo: view.trailingAnchor))
		NSLayoutConstraint.activate(hudLayoutConstraints)
		
	}
	
	func ifTripInformationAreEmptyAlert() {
		let alert = UIAlertController(title: "First:", message: "Insert Trip name and/or Trip date", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	func alertSaveTripBecauseOfSetImage() {
		let alert = UIAlertController(title: "Are you sure?", message: "If you wanna set image for Trip, first you need to save new Trip. \nDo you wanna save new trip?", preferredStyle: .alert)
		let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
			self.saveTripWhenSetImageToTrip()
			self.performSegue(withIdentifier: "setPhoto", sender: nil)
		}
		let noAction = UIAlertAction(title: "No", style: .default) { (action) in
			self.imageSwitchIsOff()
		}
		alert.addAction(yesAction)
		alert.addAction(noAction)
		present(alert, animated: true, completion: nil)
	}
	
	func saveTripWhenSetImageToTrip() {
		
		let entity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
		let newTrip = NSManagedObject(entity: entity, insertInto: managedContext) as! Trip
		
		addSearchKey()
		if pickedDate == nil {
			pickedDate = Date()
		}
		if tripNameTextField.text == "" {
			tripNameTextField.text = "No Destination Name"
		}
		newTrip.name = tripNameTextField.text
		newTrip.date = pickedDate as NSDate?
		newTrip.searchKey = self.searchKey
		
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could Not Save New Trip \(error), \(error.userInfo)")
		}
	}
	
	func imageSwitchIsOff() {
		self.imageSwitch.isOn = false
	}

	
}
