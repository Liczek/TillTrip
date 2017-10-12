//
//  Trip+CoreDataProperties.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 12.10.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var info: String?
    @NSManaged public var name: String?
    @NSManaged public var searchKey: String?
    @NSManaged public var bgImage: FullRes?

}
