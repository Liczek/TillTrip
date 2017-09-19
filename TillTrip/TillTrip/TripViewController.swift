//
//  TripViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 19.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit
import CoreData

class TripViewController: UIViewController {
	
	var datePicker = UIDatePicker()
	var managedContext: NSManagedObjectContext!
	var searchKey = "2"
	var trips = [Trip]()
	
	@IBOutlet weak var tripNameTextField: UITextField!
	@IBOutlet weak var tripDateTextField: UITextField!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		

		
		if searchKey != nil {
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			managedContext = appDelegate.persistentContainer.viewContext
			
			let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
			fetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchKey)
			
			do {
				trips = try managedContext.fetch(fetchRequest)
				
				guard let tripToEdit = trips.first else {return}
				print("number of trips\(String(describing: tripToEdit.name))")
				tripNameTextField.text = tripToEdit.name
				tripDateTextField.text = dateConverterToString(from: tripToEdit.date! as Date)
				
				
				
			} catch let error as NSError {
				print("Could Not Load/Create Trip \(error), \(error.userInfo)")
			}
			
		} else {
			let uniqueID = UUID().uuidString
			searchKey = uniqueID
		}
		createDatePicker()

		
    }
	
	@IBAction func addTripButtonTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}

	func createDatePicker() {
		
		datePicker.datePickerMode = .date
		
		
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePicking))
		toolBar.setItems([doneButton], animated: true)
		tripDateTextField.inputAccessoryView = toolBar
		tripDateTextField.inputView = datePicker
	}
	
	func doneDatePicking() {
		
		let pickedDate = datePicker.date
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .full
		dateFormatter.dateFormat = "dd MMMM YYYY"
		let reformatedDate = dateFormatter.string(from: pickedDate)
		tripDateTextField.text = "\(reformatedDate)"
		self.view.endEditing(true)
	}
	
	func dateConverterToString(from date: Date) -> String{
		
		let pickedDate = date
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .full
		dateFormatter.dateFormat = "dd MMMM YYYY"
		let reformatedDate = dateFormatter.string(from: pickedDate as Date)
		return reformatedDate
	}
	
	func saveTrip() {
		
	}

	
}
