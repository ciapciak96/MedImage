//
//  folderCell.swift
//  MedImage
//
//  Created by Vanda S. on 22/06/2022.
//

import UIKit

class FolderCell: UICollectionViewCell {
    
    static let identifier = "FolderCell"
    
    private let folderName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Very long text to check the label"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.8)
        return label
    }()
    
    private let folderImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .systemPink
        image.layer.cornerRadius = 10
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViewsAndLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addSubViewsAndLayout() {
        contentView.addSubview(folderName)
        contentView.addSubview(folderImage)
        
        folderImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        folderImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        folderImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        folderImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50).isActive = true
        
        folderName.topAnchor.constraint(equalTo: folderImage.bottomAnchor, constant: 2).isActive = true
        folderName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        folderName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        folderName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
