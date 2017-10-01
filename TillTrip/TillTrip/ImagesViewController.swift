////
////  ImagesViewController.swift
////  TillTrip
////
////  Created by Paweł Liczmański on 25.09.2017.
////  Copyright © 2017 Paweł Liczmański. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class ImagesViewController: UIViewController {
//
//	@IBOutlet weak var imageView: UIImageView!
//	
//	let imagePicker = UIImagePickerController()
//	
//	
//	// dispatch queues
//	let convertQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)
//	let saveQueue = DispatchQueue(label: "saveQueue", attributes: .concurrent)
//	
//	//ManagedObjectContext
//	var managedContext: NSManagedObjectContext?
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		
//		
//		imagePickerSetup()
//		
//		coreDataSetup()
//		
//	}
//	
//	//this function displey the imagePicker
//	
//	@IBAction func captureImage(_ sender: Any) {
//		present(imagePicker, animated: true, completion: nil)
//	}
//	
//	@IBAction func loadImage(_ sender: Any) {
//		
//		loadImages { (images) -> Void in
//			if let thumbnailData = images?.last?.thumbnail?.imageData {
//				let image = UIImage(data: thumbnailData as Data)
//				self.imageView.image = image
//			}
//			
//		}
//		
//	}
//	
//	
//	
//}
//
//
//extension ImagesViewController {
////	this function sets a value to managedContext on the correct
////	thread. Since CoreData needs all operations in one
////	NSManagedObjectContext to happen in the same thread.
//	func coreDataSetup() {
//		saveQueue.sync {
//			self.managedContext = AppDelegate().managedObjectContext
//		}
//	}
//}
//
//extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//	
//	
//	func imagePickerSetup() {
//		
//		
//		imagePicker.delegate = self
//		imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//		
//	}
//	// When an image is "picked" it will return through this function
//	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//		self.dismiss(animated: true, completion: nil)
//		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//		prepareImageForSaving(image: image)
//	}
//
//	
//}
//
//extension ImagesViewController {
//	
//	func prepareImageForSaving(image: UIImage) {
//		
//		// use date as unique id
//		let date: Double = NSDate().timeIntervalSince1970
//		
//		//dispatch with Grand Central Dispatch
//		convertQueue.async {
//			
//			//create NSData from UIImage
//			guard let imageData = UIImageJPEGRepresentation(image, 1) else {
//				
//				print("Could not convert UIImage to NSData")
//				return
//			}
//			
//			let thumbnail = image.scale(toSize: self.view.frame.size)
//			
//			guard let thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.7) else {
//				print("Could not convert thumbnail to NSData")
//				return
//			}
//			
//			self.saveImage(imageData: imageData as NSData, thumbnailData: thumbnailData as NSData, date: date)
//		}
//		
//	}
//}
//
//extension ImagesViewController {
//	func saveImage(imageData: NSData, thumbnailData: NSData, date: Double) {
//		saveQueue.sync {
//			
//			//create new object in managedContext
//			guard let moc = self.managedContext else {
//				return
//			}
//			
//			guard let fullRes = NSEntityDescription.insertNewObject(forEntityName: "FullRes", into: moc) as? FullRes,
//					let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: moc) as? Thumbnail
//			else {
//				print("moc error")
//				return
//			}
//			
//			//set image data of fullres
//			fullRes.imageData = imageData
//			
//			//set image data for thumbnail
//			thumbnail.imageData = thumbnailData
//			thumbnail.id = date
//			thumbnail.fullRes = fullRes
//			
//			//save the new objects
//			do {
//				try moc.save()
//			} catch let error as NSError {
//				print("Could not Save fullRes and Thumb \(error)")
//			}
//			
//			//clear teh moc
//			moc.refreshAllObjects()
//			
//		}
//	}
//}
//
//extension ImagesViewController {
//	
//	func loadImages(fetched:@escaping (_ images:[FullRes]?) -> Void) {
//		saveQueue.async {
//			guard let moc = self.managedContext else {
//				return
//			}
//			
//			let fetchRequest = NSFetchRequest<FullRes>(entityName: "FullRes")
//			
//			do {
//				let results = try moc.fetch(fetchRequest)
//				let imageData = results as [FullRes]
//				DispatchQueue.main.async {
//					fetched(imageData)
//				}
//			} catch let error as NSError {
//				print("Could not fetch \(error), \(error.userInfo)")
//				return
//				
//			}
//		}
//	}
//}
//
//extension CGSize {
//	
//	func resizeFill(toSize: CGSize) -> CGSize {
//		
//		let scale: CGFloat = (self.height / self.width) < (toSize.height / toSize.width) ? (self.height / toSize.height) : (self.width / toSize.width)
//		return CGSize(width: (self.width / scale), height: (self.height / scale))
//	}
//}
//
//extension UIImage {
//	
//	func scale(toSize newSize: CGSize) -> UIImage {
//		
//		// mae sure the new size has the correct aspect ratio
//		let aspectFill = self.size.resizeFill(toSize: newSize)
//		
//		UIGraphicsBeginImageContextWithOptions(aspectFill, false, 0.0);
//		self.draw(in: CGRect(x: 0, y: 0, width: aspectFill.width, height: aspectFill.height))
//		
//		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//		UIGraphicsEndImageContext()
//		
//		return newImage
//	}
//}
