//
//  ImageExtension.swift
//  MedImage
//
//  Created by Vanda S. on 04/07/2022.
//

import Foundation
import UIKit

func resizedImage(sourceImage: UIImage, scaledToWidth: CGFloat) -> UIImage {
    let oldWidth = sourceImage.size.width
    let scaleFactor = scaledToWidth / oldWidth
    
    let newHeight = sourceImage.size.height * scaleFactor
    let newWidth = oldWidth * scaleFactor
    
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}
