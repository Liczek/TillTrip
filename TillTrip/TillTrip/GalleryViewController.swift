//
//  GalerieViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 01.10.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit
import CoreData

class GalleryViewController: UIViewController {
	
	var bgImages = [FullRes]()
	var trips = [Trip]()
	var trip = Trip()
	var tableView = UITableView()
	var getNewPhotoButton = UIButton()
	var addSamplePhotoButton = UIButton()
	var removeAllPhotosButton = UIButton()
	
	var universalLayoutConstraints = [NSLayoutConstraint]()
	var imagePicker = UIImagePickerController()
	var managedContext: NSManagedObjectContext!
	var isEditingPhoto = false
	var searchKeyForSelectedTrip: String?
	
	var verticalGap: CGFloat = 15
	var horizontalGap: CGFloat = 5
	
	var hud = HudView()
	var hudLayoutConstraints = [NSLayoutConstraint]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		insertStarterData()
		
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		
		do {
			bgImages = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Fetch bgImages \(error), \(error.userInfo)")
		}
		
		view.backgroundColor = UIColor.black
		
		tableView.register(TripMenuCell.self, forCellReuseIdentifier: "TripMenuCell")
		tableView.separatorColor = UIColor.clear
		
		view.addSubview(getNewPhotoButton)
		view.addSubview(tableView)
		view.addSubview(addSamplePhotoButton)
		view.addSubview(removeAllPhotosButton)
		
		universalConstraints()
		configureButton()
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.black
		
		getNewPhotoButton.addTarget(self, action: #selector(imagePickerSourceType), for: .touchUpInside)
		imagePicker.delegate = self
		
		removeAllPhotosButton.addTarget(self, action: #selector(removeAllPhotosFromGallery), for: .touchUpInside)
		
		if searchKeyForSelectedTrip != nil {
		
			let tripFetch = NSFetchRequest<Trip>(entityName: "Trip")
			tripFetch.predicate = NSPredicate(format: "searchKey == %@", searchKeyForSelectedTrip!)
			
			do {
				trips = try managedContext.fetch(tripFetch)
					trip = trips.first!
				
			} catch let error as NSError {
				print("Could Not Find Selected Trip \(error), \(error.userInfo)")
			}
			if trip.imageName == nil {
				displayAlertForBGImageSet()
			}
		} else {
			return
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		
		do {
			bgImages = try managedContext.fetch(fetchRequest)
		} catch let error as NSError {
			print("Could Not Fetch bgImages \(error), \(error.userInfo)")
		}
		
		tableView.reloadData()
	}
	
	func universalConstraints() {
		
		getNewPhotoButton.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		addSamplePhotoButton.translatesAutoresizingMaskIntoConstraints = false
		removeAllPhotosButton.translatesAutoresizingMaskIntoConstraints = false
		
		//buttons
		universalLayoutConstraints.append(getNewPhotoButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: verticalGap))
		universalLayoutConstraints.append(getNewPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
		
		universalLayoutConstraints.append(addSamplePhotoButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: view.frame.size.width * 0.25))
		universalLayoutConstraints.append(addSamplePhotoButton.widthAnchor.constraint(equalTo: getNewPhotoButton.widthAnchor, multiplier: 0.6))
		universalLayoutConstraints.append(addSamplePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -horizontalGap * 0.5))
		
		universalLayoutConstraints.append(removeAllPhotosButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -view.frame.size.width * 0.25))
		universalLayoutConstraints.append(removeAllPhotosButton.widthAnchor.constraint(equalTo: getNewPhotoButton.widthAnchor, multiplier: 0.6))
		universalLayoutConstraints.append(removeAllPhotosButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -horizontalGap * 0.5))
		
		//tableView
		universalLayoutConstraints.append(tableView.topAnchor.constraint(equalTo: getNewPhotoButton.bottomAnchor, constant: verticalGap))
		universalLayoutConstraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalGap))
		universalLayoutConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalGap))
		universalLayoutConstraints.append(tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -verticalGap * 2))

		
		NSLayoutConstraint.activate(universalLayoutConstraints)
	}
	
	func configureButton() {
		getNewPhotoButton.clipsToBounds = true
		getNewPhotoButton.layer.cornerRadius = 10
		getNewPhotoButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
		getNewPhotoButton.layer.borderWidth = 1.5
		getNewPhotoButton.layer.borderColor = UIColor.white.withAlphaComponent(1).cgColor
		getNewPhotoButton.setTitle("Add New Photo", for: .normal)
		getNewPhotoButton.setTitleColor(UIColor.black, for: .normal)
		getNewPhotoButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
		
		addSamplePhotoButton.clipsToBounds = true
		addSamplePhotoButton.layer.cornerRadius = 5
		addSamplePhotoButton.backgroundColor = UIColor.clear
		addSamplePhotoButton.layer.borderWidth = 0.5
		addSamplePhotoButton.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
		addSamplePhotoButton.setTitle("Add Starter Photos", for: .normal)
		addSamplePhotoButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
		addSamplePhotoButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
		addSamplePhotoButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
		
		removeAllPhotosButton.clipsToBounds = true
		removeAllPhotosButton.layer.cornerRadius = 5
		removeAllPhotosButton.backgroundColor = UIColor.clear
		removeAllPhotosButton.layer.borderWidth = 0.5
		removeAllPhotosButton.layer.borderColor = UIColor.white.withAlphaComponent(0.6).cgColor
		removeAllPhotosButton.setTitle("Clear Gallerie", for: .normal)
		removeAllPhotosButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
		removeAllPhotosButton.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .normal)
		removeAllPhotosButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
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
		
		alert.view.tintColor = UIColor.black
		
		
		alert.addAction(camera)
		alert.addAction(photoLibrary)
		alert.addAction(cancel)
		
		
		
		
		present(alert, animated: true, completion: nil)
	}
	
	func openImagePickerLibrary() {
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = true
		present(imagePicker, animated: true, completion: nil)
	}
	
	func openImagePickerCamera() {
		imagePicker.sourceType = .camera
		imagePicker.allowsEditing = true
		present(imagePicker, animated: true, completion: nil)
	}
	
	func displayAlertForBGImageSet() {
		if isEditingPhoto == true {
			let alert = UIAlertController(title: "Choose photo", message: "Tap on image which you want add to your trip or add new photo to gallery from your camera or photo library", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(okAction)
			
			alert.view.tintColor = UIColor.black
			
			present(alert, animated: true, completion: nil)
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			managedContext = appDelegate.persistentContainer.viewContext
			let tripFetch = NSFetchRequest<Trip>(entityName: "Trip")
			tripFetch.predicate = NSPredicate(format: "searchKey == %@", searchKeyForSelectedTrip!)
			
			do {
				trips = try managedContext.fetch(tripFetch)
				trip = trips.first!
			} catch let error as NSError {
				print("Could Not Find Selected Trip \(error), \(error.userInfo)")
			}
		}
	}
}

extension GalleryViewController {
	
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
		let dataArray = NSArray(contentsOfFile: path!)!
		
		for data in dataArray {
			let entity = NSEntityDescription.entity(forEntityName: "FullRes", in: managedContext)!
			let image = FullRes(entity: entity, insertInto: managedContext)
			
			guard let imageDict = data as? [String: AnyObject] else {return}
			
			image.imageName = imageDict["imageName"] as? String
			do {
				try managedContext.save()
			} catch let error as NSError {
				print("Could Not Save Inserted Starter Data \(error), \(error.userInfo)")
			}
		}
	}
}

extension GalleryViewController: UITableViewDelegate, UITableViewDataSource {
	
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
		var numberOfRows = Int()
		if bgImages.count == 0 {
			numberOfRows = 1
		} else {
			numberOfRows = bgImages.count
		}
		return numberOfRows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "TripMenuCell", for: indexPath) as! TripMenuCell
		cell.destination.isHidden = true
		cell.dayLeft.isHidden = true
		cell.destinationName.isHidden = true
		cell.dayLeftNumber.isHidden = true
		
		if bgImages == [] {
			cell.bgImage.image = UIImage(named: "No_image")
			cell.bgImage.contentMode = .scaleAspectFit
		} else {
			let image = bgImages[indexPath.row]
			if image.imageData == nil {
				cell.bgImage.image = UIImage(named: image.imageName!)
			} else {
				let convertedImageData: Data = image.imageData! as Data
				cell.bgImage.image = UIImage(data: convertedImageData)
			}
		}
		cell.selectionStyle = .none
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		
		do {
			let imageToRemove = try managedContext.fetch(fetchRequest)[indexPath.row]
			managedContext.delete(imageToRemove)
			bgImages.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			
		} catch let error as NSError {
			print("Could Not Find Selected Image \(error), \(error.userInfo)")
		}
		
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Could Not Save After Remove Image \(error), \(error.userInfo)")
		}
	}
	
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
		if isEditingPhoto == false {
			print("is Editing Photo == false")
			return
			
		} else {
			let selectedImage = bgImages[indexPath.row]
			let selectedImageName = selectedImage.imageName
			let selectedImageData = selectedImage.imageData
			
			
			
			
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
			managedContext = appDelegate.persistentContainer.viewContext
			let tripFetch = NSFetchRequest<Trip>(entityName: "Trip")
			tripFetch.predicate = NSPredicate(format: "searchKey == %@", searchKeyForSelectedTrip!)
			
			do {
				trips = try managedContext.fetch(tripFetch)
				guard let tripToEdit = trips.first else { return }
				tripToEdit.imageName = selectedImageName
				tripToEdit.imageData = selectedImageData
				
				hud.hudNameLabel.text = "SAVED"
				if selectedImageData != nil {
					hud.hudImage.image = UIImage(data: selectedImageData! as Data)
				} else {
					hud.hudImage.image = UIImage(named: selectedImageName!)
				}
				
				showHUD()
				print( isEditingPhoto)
				
				let when = DispatchTime.now() + 1.8
				DispatchQueue.main.asyncAfter(deadline: when){
					// your code with delay
					self.hud.removeFromSuperview()
				}
				
			} catch let error as NSError {
				print("Could Not Find Selected Trip \(error), \(error.userInfo)")
			}
			
			


			do {
				try managedContext.save()
			} catch let error as NSError {
				print("Could Not Save photo in Selected Trip  \(error), \(error.userInfo)")
			}
//TODO: dowiedzieć się czemu nie działał dismiss
			//self.dismiss(animated: true, completion: nil)
			
		}
	}
	
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		let pickedImage = info[UIImagePickerControllerEditedImage] as! UIImage
		guard let imageData = UIImageJPEGRepresentation(pickedImage, 1) else {
			print("Could not convert UIImage to NSData")
			return
		}
		let imageName = String(NSDate().timeIntervalSince1970)
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let managedContext = appDelegate.persistentContainer.viewContext
		let entity = NSEntityDescription.entity(forEntityName: "FullRes", in: managedContext)!
		let fullRes = FullRes(entity: entity, insertInto: managedContext)
		
		fullRes.imageData = imageData as NSData
		fullRes.imageName = imageName as String
		managedContext.insert(fullRes)
		
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
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
		
		dismiss(animated: true, completion: nil)
		
		
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
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
}

extension GalleryViewController {
	func removeAllPhotosFromGallery() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
		managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
		let emptyArray = [FullRes]()
		do {
			bgImages = try managedContext.fetch(fetchRequest)
			bgImages = emptyArray
		} catch let error as NSError {
			print("Could Not Fetch bgImages \(error), \(error.userInfo)")
		}
		
		try! managedContext.save()
		tableView.reloadData()

	}
}
