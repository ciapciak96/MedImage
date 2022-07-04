//
//  folderCell.swift
//  MedImage
//
//  Created by Vanda S. on 22/06/2022.
//

import UIKit

class FolderCell: UICollectionViewCell {
    
    static let identifier = "FolderCell"
    
    var isInEditingMode = false 

     let folderName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
         label.font = .systemFont(ofSize: 15, weight: .regular)
         label.textColor = UIColor(named: "mainColor")?.withAlphaComponent(0.9)
        return label
    }()
    
     let folderImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        //image.backgroundColor = .systemPink
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFit
         image.image = UIImage(systemName: "folder.fill")?.withTintColor(.systemGray2.withAlphaComponent(0.5), renderingMode: .alwaysOriginal)
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
        folderName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13).isActive = true
        folderName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13).isActive = true
        folderName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
