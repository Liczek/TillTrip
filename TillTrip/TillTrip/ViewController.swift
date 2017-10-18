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
	var bgImages = [FullRes]()
	var bgImagesDecreasingArray = [FullRes]()
	var managedContext: NSManagedObjectContext!
	var searchKeyOfSelectedTrip = String()
	var selectedTripImageName = String()
	var universalConstraints = [NSLayoutConstraint]()
	
	var refresher: UIRefreshControl!

	
	let tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		refresherConfiguration()
		insertStarterData()
		insertStarterImages()
		bgImagesDecreasingArray = bgImages
		
		let fetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
		fetchRequest.predicate = NSPredicate(format: "name != nil")
		let fetchRequestFullRes = NSFetchRequest<FullRes>(entityName: "FullRes")
		do {
			trips = try managedContext.fetch(fetchRequest)
			bgImages = try managedContext.fetch(fetchRequestFullRes)
		} catch let error as NSError {
			print("Could not fetch plist data \(error)")
		}
		
		
		
		
		view.addSubview(tableView)
		configureUniversalConstraints()
		tableView.register(TripMenuCell.self, forCellReuseIdentifier: "TripMenuCell")
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.black
		
		navigationController?.navigationBar.tintColor = UIColor.white
		
		let refreshImages = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBackgrounds))
		let imagesCatalog = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(openImageCatalog))
		let addTripButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTrip))
		
		navigationItem.leftBarButtonItems = [refreshImages, imagesCatalog]
		navigationItem.rightBarButtonItem = addTripButton
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		
		
		
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
		let fetchRequestFullRes = NSFetchRequest<FullRes>(entityName: "FullRes")
		let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			trips = try managedContext.fetch(fetchRequest)
			bgImages = try managedContext.fetch(fetchRequestFullRes)
		} catch let error as NSError {
			print("Could Not Reload View \(error), \(error.userInfo)")
		}
		bgImagesDecreasingArray = bgImages
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
		bgImagesDecreasingArray = bgImages
		tableView.reloadData()
	}
	
	func openImageCatalog() {
		performSegue(withIdentifier: "Galeries", sender: self)
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
		if statusBar == 0.0 {
			tableViewHeight = tableView.frame.size.height - 20
		} else {
			tableViewHeight = tableView.frame.size.height
		}
		var rowHeight = CGFloat()
		if traitCollection.verticalSizeClass == .regular {
			rowHeight = tableViewHeight / 3
		} else if traitCollection.verticalSizeClass == .compact {
			rowHeight = (tableViewHeight + 20)  / 2
		}
		return rowHeight
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return trips.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		let trip = trips[indexPath.row]
		
		
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "TripMenuCell", for: indexPath) as! TripMenuCell
		
		if bgImages.isEmpty {
			
			if trip.imageData != nil {
				let tripImageData: Data = trip.imageData! as Data
				cell.bgImage.image = UIImage(data: tripImageData)
				cell.mainImage.image = UIImage(data: tripImageData)
			} else if trip.imageName != nil {
				let tripImageName = trip.imageName! as String
				cell.bgImage.image = UIImage(named: tripImageName)
				cell.mainImage.image = UIImage(named: tripImageName)
			} else {
				cell.bgImage.image = UIImage(named: "No_image")
				cell.bgImage.contentMode = .scaleAspectFit
				cell.mainImage.image = UIImage(named: "No_image")
				cell.mainImage.contentMode = .scaleAspectFill
			}
			
		
			
		} else {
			
			if bgImagesDecreasingArray.count < trips.count {
				bgImagesDecreasingArray += bgImages
			}
			
			let maxIndex = bgImagesDecreasingArray.count
			let randomImageIndex = arc4random_uniform(UInt32(maxIndex))
			let image = bgImagesDecreasingArray[Int(randomImageIndex)]
			let imageName = bgImagesDecreasingArray[Int(randomImageIndex)].imageName!
			bgImagesDecreasingArray.remove(at: Int(randomImageIndex))
			
			
			
			
			if trip.imageData != nil {
				let tripImageData: Data = trip.imageData! as Data
				cell.bgImage.image = UIImage(data: tripImageData)
				cell.mainImage.image = UIImage(data: tripImageData)
			} else if trip.imageName != nil {
				let tripImageName = trip.imageName! as String
				cell.bgImage.image = UIImage(named: tripImageName)
				cell.mainImage.image = UIImage(named: tripImageName)
			} else {
				if image.imageData == nil {
					cell.bgImage.image = UIImage(named: image.imageName!)
					cell.mainImage.image = UIImage(named: image.imageName!)
				} else {
					let convertedImageData: Data = image.imageData! as Data
					cell.bgImage.image = UIImage(data: convertedImageData)
					cell.mainImage.image = UIImage(data: convertedImageData)
				}
				
			}
			
			if  cell.bgImage.image == UIImage(named:"No_image") {
				cell.bgImage.contentMode = .scaleAspectFit
				cell.mainImage.contentMode = .scaleAspectFill
			} else {
				cell.bgImage.contentMode = .scaleToFill
				cell.bgImageName = imageName
				cell.mainImage.contentMode = .scaleAspectFill
			}
		}
		
		
		cell.selectionStyle = .none
		
		cell.destinationName.text = trip.name
		cell.destinationName.textColor = UIColor.white
		cell.searchKey = trip.searchKey
		cell.bgImage.alpha = 0.75
		cell.leftMainImage.image = cell.mainImage.image
		cell.rightMainImage.image = cell.mainImage.image
		
//MARK: Blur for bgImage
//		let blurRadius: CGFloat = 3
//		if let imageToBlur = cell.bgImage.image {
//		let beginImage = CIImage(image: imageToBlur)
//		var blurfilter = CIFilter(name: "CIGaussianBlur")
//		blurfilter?.setValue(beginImage, forKey: "inputImage")
//		blurfilter?.setValue(blurRadius, forKey: kCIInputRadiusKey)
//			var resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
//			var bluredImage = UIImage(ciImage: resultImage)
//			cell.bgImage.image = bluredImage
//		}
		let daysTillTrip = daysBetweenDates(firstDate: Date(), secondDate: trip.date! as Date)
		
		
		if 11...30 ~= daysTillTrip {
			cell.dayLeftNumber.textColor = UIColor.yellow.withAlphaComponent(0.85)
		} else if 4...10 ~= daysTillTrip {
			cell.dayLeftNumber.textColor = UIColor.orange.withAlphaComponent(0.85)
		} else if 2...3 ~= daysTillTrip {
			cell.dayLeftNumber.textColor = UIColor.red.withAlphaComponent(0.85)
		} else if 0...1 ~= daysTillTrip {
			cell.dayLeftNumber.textColor = UIColor.green.withAlphaComponent(0.85)
		} else {
			cell.dayLeftNumber.textColor = UIColor.white.withAlphaComponent(0.85)
		}
		cell.dayLeftNumber.text = "\(daysTillTrip)"
		
		return cell
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let cell = tableView.cellForRow(at: indexPath) as! TripMenuCell
		
		self.searchKeyOfSelectedTrip = cell.searchKey
		self.selectedTripImageName = cell.bgImageName
		
		performSegue(withIdentifier: "EditTripDetails", sender: searchKeyOfSelectedTrip)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "EditTripDetails" {
			
			let controller = segue.destination as! TripViewController 
				controller.searchKey = sender as? String
				controller.imageName = selectedTripImageName
		}
	}
	
	func insertStarterImages() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		fetchRequest.predicate = NSPredicate(format: "imageName != nil")
		
		
		do {
			let result = try managedContext.count(for: fetchRequest)
			if result > 0 {return}
		} catch let error as NSError {
			print("Could not fetch plist data \(error)")
		}
		
		for (_, element) in arrayOfImages.enumerated() {
			let entity = NSEntityDescription.entity(forEntityName: "FullRes", in: managedContext)!
			let fullRes = FullRes(entity: entity, insertInto: managedContext)
			fullRes.imageName = String(element)
			
			managedContext.insert(fullRes)
		}
		
		
		
		
		do {
			bgImages = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Save FullRes after add new one \(error), \(error.userInfo)")
		}
		
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could Not Save FullRes after add new one \(error), \(error.userInfo)")
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
		let cell = tableView.cellForRow(at: indexPath) as! TripMenuCell
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
		let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			trips = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Set trips after Deleting Trip \(error), \(error.userInfo)")
		}
		
		
		
		do {
			try managedContext.save()
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
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
	
	func refresherConfiguration() {
		
		refresher = UIRefreshControl()
		refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSForegroundColorAttributeName : UIColor.white])
		refresher.addTarget(self, action: #selector(reloadTable), for: UIControlEvents.valueChanged)
		refresher.tintColor = UIColor.white
		tableView.addSubview(refresher)
		
	}
	func reloadTable() {
		tableView.reloadData()
		refresher.endRefreshing()
	}

}












