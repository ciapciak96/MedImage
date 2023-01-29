//
//  OnboardingCollectionViewCell.swift
//  MedImage
//
//  Created by Vanda S. on 02/11/2022.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var instructionsImageView: UIImageView!
    
    
    func setup(_ slide: OnboardingSlide) {
        titleLabel.text = slide.title
        titleLabel.minimumScaleFactor = 0.3
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        instructionsTextView.text = slide.description
        instructionsTextView.adjustsFontForContentSizeCategory = true
        instructionsImageView.image = slide.image
        instructionsImageView.contentMode = .scaleAspectFit
    }
    

}
