//
//  Image+CoreDataProperties.swift
//  MedImage
//
//  Created by Vanda S. on 23/06/2022.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var folder: Folder?

}

extension Image : Identifiable {

}
