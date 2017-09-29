//
//  ViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 14.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var arrayOfImages = ["thai1", "thai2", "thai3", "thai4", "thai5", "thai6", "thai7", "thai8", "thai9", "thai10", "thai11", "thai12", "thai13"]
	var images: [String]!
	var trips = [Trip]()
	var managedContext: NSManagedObjectContext!
	var searchKeyOfSelectedTrip = String()
	var selectedTripImageName = String()
	var universalConstraints = [NSLayoutConstraint]()

	
	let tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("status bar: \(UIApplication.shared.statusBarFrame.height)")
		print("navigation bar: \(String(describing: self.navigationController?.navigationBar.frame.height))")
		print("tool bar: \(String(describing: self.navigationController?.toolbar.frame.height))")
		
		
		
		view.addSubview(tableView)
		configureUniversalConstraints()
		tableView.register(TripMenuCell.self, forCellReuseIdentifier: "TripMenuCell")
		
		tableView.delegate = self
		tableView.dataSource = self
		
		images = arrayOfImages
		
		navigationController?.navigationBar.tintColor = UIColor.white
		
		let refreshImages = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBackgrounds))
		let imagesCatalog = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(openImageCatalog))
		let addTripButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrip))
		
		navigationItem.leftBarButtonItems = [refreshImages, imagesCatalog]
		navigationItem.rightBarButtonItem = addTripButton
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		insertStarterData()
		
		let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
		fetchRequest.predicate = NSPredicate(format: "name != nil")
		
		do {
			trips = try managedContext.fetch(fetchRequest)
			
		} catch let error as NSError {
			print("Could not fetch plist data \(error)")
		}
		
		
		tableView.delegate = self
		tableView.backgroundColor = UIColor.clear
		tableView.separatorColor = UIColor.clear
		title = "TillTrip"
		view.backgroundColor = UIColor.black
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<Trip>(entityName:"Trip")
		let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			trips = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Reload View \(error), \(error.userInfo)")
		}
		tableView.reloadData()
	}
	
	func configureUniversalConstraints() {
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		universalConstraints.append(tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
		universalConstraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5))
		universalConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5))
		universalConstraints.append(tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -3))
		
		NSLayoutConstraint.activate(universalConstraints)
		
	}
	
	func refreshBackgrounds() {
		images = arrayOfImages
		tableView.reloadData()
	}
	
	func openImageCatalog() {
		performSegue(withIdentifier: "GoToImagesPicker", sender: self)
		print("Number of images\(images.count) / \(arrayOfImages.count)")
	}
	
	func addTrip() {
		performSegue(withIdentifier: "AddTrip", sender: self)
	}

	@IBAction func refreshView(_ sender: UIBarButtonItem) {
		tableView.reloadData()
	}
	
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		var tableViewHeight = CGFloat()
		let statusBar = UIApplication.shared.statusBarFrame.height
		print("status bar: \(UIApplication.shared.statusBarFrame.height)")
		if statusBar == 0.0 {
			tableViewHeight = tableView.frame.size.height - 20
		} else {
			tableViewHeight = tableView.frame.size.height
		}
		var rowHeight = CGFloat()
		if traitCollection.verticalSizeClass == .regular {
			rowHeight = tableViewHeight / 3
			print("pionowo \(tableViewHeight)")
		} else if traitCollection.verticalSizeClass == .compact {
			rowHeight = (tableViewHeight + 20)  / 2
			print("poziomo \(tableViewHeight)")
		}
		return rowHeight
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return trips.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		let trip = trips[indexPath.row]

		let cell = tableView.dequeueReusableCell(withIdentifier: "TripMenuCell", for: indexPath) as! TripMenuCell
		
		if images.count < trips.count {
			images = arrayOfImages
		}
		let maxIndex = images.count
		let randomImageIndex = arc4random_uniform(UInt32(maxIndex))
		let imageName = images[Int(randomImageIndex)]
		images.remove(at: Int(randomImageIndex))
		
		print(imageName)
		cell.bgImage.image = UIImage(named: imageName)
		cell.bgImage.contentMode = .scaleToFill
		
		cell.destinationName.text = trip.name
		cell.destinationName.textColor = UIColor.white
		cell.searchKey = trip.searchKey
		cell.bgImageName = imageName
		let daysTillTrip = daysBetweenDates(firstDate: Date(), secondDate: trip.date! as Date)
		
		cell.dayLeftNumber.text = "\(daysTillTrip)"
		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.cellForRow(at: indexPath) as! TripMenuCell
		
		self.searchKeyOfSelectedTrip = cell.searchKey
		self.selectedTripImageName = cell.bgImageName
		print("searchKey name - sender: \(searchKeyOfSelectedTrip)")
		performSegue(withIdentifier: "EditTripDetails", sender: searchKeyOfSelectedTrip)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "EditTripDetails" {
			
			let controller = segue.destination as! TripViewController 
				controller.searchKey = sender as? String
				controller.imageName = selectedTripImageName
		}
	}
	
	func insertStarterData() {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		
		let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
		fetchRequest.predicate = NSPredicate(format: "name != nil")
		
		
		do {
			let result = try managedContext.count(for: fetchRequest)
			if result > 0 {return}
		} catch let error as NSError {
			print("Could not fetch plist data \(error)")
		}

		
		
		let path = Bundle.main.path(forResource: "TripInfo", ofType: "plist")
		let dataArray = NSArray(contentsOfFile: path!)!
		
		for data in dataArray {
			
			let entity = NSEntityDescription.entity(forEntityName: "Trip", in: managedContext)!
			let trip = Trip(entity: entity, insertInto: managedContext)
			
			guard let tripDict = data as? [String: AnyObject] else {return}
			
			
			trip.name = tripDict["name"] as? String
			trip.info = tripDict["days"] as? String
			trip.date = tripDict["date"] as? NSDate
			trip.searchKey = tripDict["searchKey"] as? String
			
		}
		
		try! managedContext.save()
	}
	
	func daysBetweenDates(firstDate: Date, secondDate: Date) -> Int
	{
		let calendar = NSCalendar.current
		
		// Replace the hour (time) of both dates with 00:00
		let date1 = calendar.startOfDay(for: firstDate)
		let date2 = calendar.startOfDay(for: secondDate)
		
		let components = calendar.dateComponents([.day], from: date1, to: date2)
		
		return components.day!
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as! Cell
		self.searchKeyOfSelectedTrip = cell.searchKey
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		managedContext = appDelegate?.persistentContainer.viewContext
		var fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
		fetchRequest.predicate = NSPredicate(format: "searchKey == %@", searchKeyOfSelectedTrip)
		do {
			guard let tripToRemove = try managedContext.fetch(fetchRequest).first else {return}
			managedContext.delete(tripToRemove)
		} catch let error as NSError {
			print("Could Not Delete Trip \(error), \(error.userInfo)")
		}
		
		fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
		do {
			trips = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Set trips after Deleting Trip \(error), \(error.userInfo)")
		}
		
		
		
		do {
			try managedContext.save()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} catch let error as NSError {
			print("Could Not Save Deleted Trip \(error), \(error.userInfo)")
		}
		
		
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
			self.tableView.setContentOffset(CGPoint.zero, animated: true)
		})
		super.viewWillTransition(to: size, with: coordinator)
	}
	
	

}












