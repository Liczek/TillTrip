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
	
	@IBOutlet weak var tripNameTextField: UITextField!
	@IBOutlet weak var tripDateTextField: UITextField!
	@IBOutlet weak var acceptTripButton: UIButton!
	@IBOutlet weak var cancelTripButton: UIButton!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		print("view will appear searchKey name in Trip: \(searchKey)")
		
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.black
		
		tripNameTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		tripNameTextField.autocapitalizationType = .sentences
		tripNameTextField.clearButtonMode = .whileEditing
		tripNameTextField.placeholder = "Set trip name"
		tripDateTextField.font = UIFont.preferredFont(forTextStyle: .headline)
		
		acceptTripButton.clipsToBounds = true
		acceptTripButton.layer.cornerRadius = 10
		acceptTripButton.backgroundColor = UIColor.darkGray
		acceptTripButton.setTitleColor(UIColor.white.withAlphaComponent(0.75), for: .normal)
		acceptTripButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
		acceptTripButton.translatesAutoresizingMaskIntoConstraints = true
		
		cancelTripButton.clipsToBounds = true
		cancelTripButton.layer.cornerRadius = 10
		cancelTripButton.backgroundColor = UIColor.darkGray
		cancelTripButton.setTitleColor(UIColor.white.withAlphaComponent(0.30), for: .normal)
		cancelTripButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		cancelTripButton.translatesAutoresizingMaskIntoConstraints = true
		
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
