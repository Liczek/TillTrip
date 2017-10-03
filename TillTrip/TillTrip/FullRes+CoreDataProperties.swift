//
//  FullRes+CoreDataProperties.swift
//  TillTrip
//
//  Created by Paweł Liczmański on 01.10.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import Foundation
import CoreData


extension FullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FullRes> {
        return NSFetchRequest<FullRes>(entityName: "FullRes")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var imageName: String?
    @NSManaged public var thumbnail: Thumbnail?

}
