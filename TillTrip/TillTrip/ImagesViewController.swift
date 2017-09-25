//
//  ImagesViewController.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 25.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var images = ["thai1", "thai2", "thai3"]
	var imagePicker = UIImagePickerController()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		imagePickerSetup()

		
		
		
		
		
		
		
    }

	
	
	@IBAction func addNewImage(_ sender: Any) {
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	

}

extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerSetup() {
		imagePicker.delegate = self
		imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
		}
	}
	
}

extension ImagesViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return images.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let imageName = images[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
		cell.textLabel?.text = imageName
		cell.imageView?.image = UIImage(named: imageName)
		return cell
	}
	
}
