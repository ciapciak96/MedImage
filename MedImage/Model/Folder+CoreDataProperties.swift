//
//  Folder+CoreDataProperties.swift
//  MedImage
//
//  Created by Vanda S. on 23/06/2022.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var name: String?
    @NSManaged public var pictures: NSSet?

}

// MARK: Generated accessors for pictures
extension Folder {

    @objc(addPicturesObject:)
    @NSManaged public func addToPictures(_ value: Image)

    @objc(removePicturesObject:)
    @NSManaged public func removeFromPictures(_ value: Image)

    @objc(addPictures:)
    @NSManaged public func addToPictures(_ values: NSSet)

    @objc(removePictures:)
    @NSManaged public func removeFromPictures(_ values: NSSet)

}

extension Folder : Identifiable {

}
