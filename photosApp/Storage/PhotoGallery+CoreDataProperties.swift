//
//  PhotoGallery+CoreDataProperties.swift
//  photosApp
//
//  Created by Tiara H on 14/06/23.
//
//

import Foundation
import CoreData


extension PhotoGallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoGallery> {
        return NSFetchRequest<PhotoGallery>(entityName: "PhotoGallery")
    }

    @NSManaged public var savedImage: Data?
    @NSManaged public var addedAt: Date?

}

extension PhotoGallery : Identifiable {

}
