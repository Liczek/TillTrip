//
//  Thumbnail+CoreDataProperties.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 14.10.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
import CoreData


extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var id: Double
    @NSManaged public var imageData: NSData?
    @NSManaged public var fullRes: FullRes?

}
