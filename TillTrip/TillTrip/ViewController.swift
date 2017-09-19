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
	
	var images = ["thai1", "thai2", "thai3", "thai4", "thai5", "thai6", "thai7", "thai8", "thai9", "thai10", "thai11", "thai12", "thai13"]
	
	let tripName = ["Trip to Thailand", "Next Trip"]
	let daysLeft = ["76", "30"]
	
	var trips = [Trip]()
	var managedContext: NSManagedObjectContext!
	

	
	@IBOutlet weak var tableView: UITableView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		
		refreshImage()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func refreshImage() {
		
	}

	@IBAction func refreshView(_ sender: UIBarButtonItem) {
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return trips.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let trip = trips[indexPath.row]

		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
		
		let maxIndex = images.count
		let randomImageIndex = arc4random_uniform(UInt32(maxIndex))
		let imageName = images[Int(randomImageIndex)]
		print(imageName)
		cell.bgImage.image = UIImage(named: imageName)
		cell.bgImage.contentMode = .scaleToFill
		
		cell.tripNameLabel.text = trip.name
		cell.tripNameLabel.textColor = UIColor.white
		
		let daysTillTrip = daysBetweenDates(firstDate: Date(), secondDate: trip.date! as Date)
		
		cell.daysLeftLabel.text = "\(daysTillTrip)"
		
		return cell
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
	
	

}












