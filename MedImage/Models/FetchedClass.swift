//
//  GlobalProperties.swift
//  MedImage
//
//  Created by Vanda S. on 26/06/2022.
//

import Foundation
import UIKit
import CoreData


class Fetched {
    
    static var pictures = [Image]()
    static var folder: Folder?
    static var globalTableView: UITableView?
    static var filteredData = [Image]()
    static var fetchedPictures = [UIImage]()
    static var filteredPictures = [UIImage]()

    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    static func fetchImagesFromDisk(fileName: String, completion: @escaping (UIImage) -> ()) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        guard let imageData = try? Data(contentsOf: fileURL) else {
            return
        }
        guard let image = UIImage(data: imageData) else {
            return
        }
        completion(image)
    }
    
}





