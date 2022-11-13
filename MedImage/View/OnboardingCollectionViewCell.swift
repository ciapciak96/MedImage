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
        instructionsTextView.text = slide.description
        instructionsImageView.image = slide.image
    }
    
    
    
    
//    static let identifier = "OnboardingCell"
//
//    var titleLabel: UILabel = {
//        let title = UILabel()
//        title.translatesAutoresizingMaskIntoConstraints = false
//        title.numberOfLines = 0
//
//        title.font = .systemFont(ofSize: 40, weight: .heavy)
//        title.textColor = .systemPink
//        title.text = "Test"
//
//        return title
//    }()
//
//    var instructionsLabel: UILabel = {
//        let instructions = UILabel()
//        instructions.translatesAutoresizingMaskIntoConstraints = false
//        instructions.numberOfLines = 0
//
//        instructions.font = .systemFont(ofSize: 20, weight: .regular)
//        instructions.textColor = .systemGray
//        instructions.text = "Testing instructions\nTesting instructions"
//        return instructions
//    }()
//
//    var instructionsImage: UIImageView = {
//        let instructionsImg = UIImageView()
//        instructionsImg.translatesAutoresizingMaskIntoConstraints = false
//        instructionsImg.backgroundColor = .systemPink
//        instructionsImg.tintColor = .systemPink
//        return instructionsImg
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubViewsAndLayout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func addSubViewsAndLayout() {
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(instructionsLabel)
//        contentView.addSubview(instructionsImage)
//
//        titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
//
//        instructionsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
//        instructionsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
//        instructionsLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
//        instructionsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        instructionsImage.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10).isActive = true
//        instructionsImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
//        instructionsImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
//        instructionsImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//
//    }
    
    

}
