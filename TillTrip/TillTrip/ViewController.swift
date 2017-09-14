//
//  ViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 14.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var images = ["thai1", "thai2", "thai3", "thai4", "thai5", "thai6", "thai7", "thai8", "thai9", "thai10", "thai11", "thai12", "thai13"]
	
	let tripName = ["Trip to Thailand"]
	let daysLeft = ["76"]

	@IBOutlet var bgImage: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.backgroundColor = UIColor.clear
		tableView.separatorColor = UIColor.clear
		title = "TillTrip"
		view.backgroundColor = UIColor.black
		bgImage.contentMode = .scaleAspectFit
		refreshImage()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func refreshImage() {
		let maxIndex = images.count
		let randomImageIndex = arc4random_uniform(UInt32(maxIndex))
		let imageName = images[Int(randomImageIndex)]
		print(imageName)
		bgImage.image = UIImage(named: imageName)
	}

	@IBAction func refreshView(_ sender: UIBarButtonItem) {
		refreshImage()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tripName.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let trip = tripName[indexPath.row]
		let day = daysLeft[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
		
		cell.tripNameLabel.text = trip
		
		cell.daysLeftLabel.text = day
		
		return cell
	}

}

