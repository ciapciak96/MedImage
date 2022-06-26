//
//  GlobalProperties.swift
//  MedImage
//
//  Created by Vanda S. on 26/06/2022.
//

import Foundation
import UIKit
import CoreData

var pictures = [Image]()
var folder: Folder?
var globalTableView: UITableView?
var filteredData = [Image]()
var fetchedPictures = [UIImage]()
var filteredPictures = [UIImage]()

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func fetchImagesFromDisk(fileName: String, completion: @escaping (UIImage) -> ()) {
    let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
    let imageData = try! Data(contentsOf: fileURL)
    let image = UIImage(data: imageData)
    completion(image!)
}



