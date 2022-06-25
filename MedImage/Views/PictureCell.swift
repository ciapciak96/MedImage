//
//  PictureCell.swift
//  MedImage
//
//  Created by Vanda S. on 22/06/2022.
//

import UIKit

class PictureCell: UITableViewCell {
    
    static let identifier = "PictureCell"

    let documentImageView: UIImageView = {
        let documentImage = UIImageView()
        documentImage.translatesAutoresizingMaskIntoConstraints = false
        documentImage.backgroundColor = .systemPink
        return documentImage
    }()
    
    let documentName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Name of the document"
        name.font = UIFont.systemFont(ofSize: 13)
        name.textColor = .black.withAlphaComponent(0.8)
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDocumentImage()
        setDocumentName()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDocumentImage() {
        contentView.addSubview(documentImageView)
        
        documentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        documentImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        documentImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        documentImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25).isActive = true
    }
    
    func setDocumentName() {
        contentView.addSubview(documentName)
        
        documentName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        documentName.leftAnchor.constraint(equalTo: documentImageView.rightAnchor, constant: 10).isActive = true
        documentName.heightAnchor.constraint(equalToConstant: 15).isActive = true
        documentName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15).isActive = true
    }
    
    
    }
