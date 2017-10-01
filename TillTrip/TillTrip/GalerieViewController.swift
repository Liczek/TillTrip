//
//  GalerieViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 01.10.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit
import CoreData

class GalerieViewController: UIViewController {

	var arrayOfImages = ["thai1", "thai2", "thai3", "thai4", "thai5", "thai6", "thai7", "thai8", "thai9", "thai10", "thai11", "thai12", "thai13"]
	
	
	var bgImages = [FullRes]()
	var tableView = UITableView()
	var getNewPhotoButton = UIButton()
	var universalLayoutConstraints = [NSLayoutConstraint]()
	var imagePicker = UIImagePickerController()
	var managedContext: NSManagedObjectContext!
	
	var verticalGap: CGFloat = 15
	var horizontalGap: CGFloat = 5
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		
		do {
			bgImages = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Fetch bgImages \(error), \(error.userInfo)")
		}
		
		
		
		
		
		view.backgroundColor = UIColor.black
		
		tableView.register(TripMenuCell.self, forCellReuseIdentifier: "TripMenuCell")
		
		view.addSubview(getNewPhotoButton)
		view.addSubview(tableView)
		
		universalConstraints()
		configureButton()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.black
		
		getNewPhotoButton.addTarget(self, action: #selector(imagePickerSourceType), for: .touchUpInside)
		imagePicker.delegate = self
    }
	
	func universalConstraints() {
		
		getNewPhotoButton.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		//button
		universalLayoutConstraints.append(getNewPhotoButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: verticalGap * 2))
		universalLayoutConstraints.append(getNewPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
		
		//tableView
		universalLayoutConstraints.append(tableView.topAnchor.constraint(equalTo: getNewPhotoButton.bottomAnchor, constant: verticalGap))
		universalLayoutConstraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap))
		universalLayoutConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -verticalGap))
		universalLayoutConstraints.append(tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -verticalGap))

		
		NSLayoutConstraint.activate(universalLayoutConstraints)
	}
	
	func configureButton() {
		getNewPhotoButton.clipsToBounds = true
		getNewPhotoButton.layer.cornerRadius = 10
		getNewPhotoButton.backgroundColor = UIColor.white
		getNewPhotoButton.setTitle("Add New Photo", for: .normal)
		getNewPhotoButton.setTitleColor(UIColor.black, for: .normal)
	}
	
	func imagePickerSourceType() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
			self.openImagePickerCamera()
		}
		let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
			self.openImagePickerLibrary()
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		alert.addAction(camera)
		alert.addAction(photoLibrary)
		alert.addAction(cancel)
		
		present(alert, animated: true, completion: nil)
	}
	
	func openImagePickerLibrary() {
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true, completion: nil)
	}
	
	func openImagePickerCamera() {
		imagePicker.sourceType = .camera
		present(imagePicker, animated: true, completion: nil)
	}


}

extension GalerieViewController {
	
	func insertStarterData() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		fetchRequest.predicate = NSPredicate(format: "imageName != nil")
		
		do {
			let result = try managedContext.count(for: fetchRequest)
			if result > 0 {return}
		} catch let error as NSError {
			print("Could not insert fake data\(error),\(error.userInfo)")
		}
		
		let path = Bundle.main.path(forResource: "FullRes", ofType: "plist")
		let dataArray = NSArray(contentsOfFile: path!)
		
		for data in dataArray {
			
		}
		
	}
	
	
}

extension GalerieViewController: UITableViewDelegate, UITableViewDataSource {
	
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
		return arrayOfImages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let imageName = arrayOfImages[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "TripMenuCell", for: indexPath) as! TripMenuCell
		cell.destination.isHidden = true
		cell.dayLeft.isHidden = true
		cell.bgImage.image = UIImage(named: imageName)
		return cell
	}
	
}

extension GalerieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		dismiss(animated: true, completion: nil)
		
		
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	
}
