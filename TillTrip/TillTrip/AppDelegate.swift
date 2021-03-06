//
//  AppDelegate.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 14.09.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	//let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//		var launchedFromShortCut = false
//		//Check for ShortCutItem
//		if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
//			launchedFromShortCut = true
//			
//		}
		return false
	}
	

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "TillTrip")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
	
	enum TouchActions: String {
		case add = "add"
		case refresh = "refresh"
		
		var number: Int {
			switch self {
			case .add:
				return 0
			case .refresh:
				return 1
			}
		}
	}
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		
//		guard let type = TouchActions(rawValue: shortcutItem.type) else {
//			completionHandler(false)
//			return
//		}
//		let selectedIndex = type.number
//		completionHandler(true)
		
		if shortcutItem.type == "com.liczmanskipawel.TillTrip.add" {
			let sb = UIStoryboard(name: "Main", bundle: nil)
			let mainVC = sb.instantiateViewController(withIdentifier: "navCon") as! UINavigationController
			let tripVC = sb.instantiateViewController(withIdentifier: "tripVC") as! TripViewController
			let root = UIApplication.shared.keyWindow?.rootViewController
			
			root?.present(mainVC, animated: false, completion: {
				mainVC.pushViewController(tripVC, animated: false)
				completionHandler(false)
			
			})
			
			
			
			
			
			
			
		}
	}
	
//	enum ShortcutType: String {
//		case add = "com.liczmanskipawel.TillTrip.add"
//		case refresh = "com.liczmanskipawel.TillTrip.refresh"
//	}
//	
//	func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
//		var handled = false
//		//Get type string from shortcutItem
//		if let shortcutType = ShortcutType.init(rawValue: shortcutItem.type) {
//			//Get root navigation viewcontroller and its first controller
//			let rootNavigationViewController = window!.rootViewController as? UINavigationController
//			let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
//			//Pop to root view controller so that approperiete segue can be performed
//			rootNavigationViewController?.popViewController(animated: false)
//			
//			switch shortcutType {
//			case .add:
//				rootViewController?.performSegue(withIdentifier: "AddTrip", sender: nil)
//				handled = true
//			case.refresh:
//				rootViewController?.performSegue(withIdentifier: "Galeries", sender: nil)
//				handled = true
//			}
//		}
//		return handled
//	}

}

