//
//  PictureCell.swift
//  MedImage
//
//  Created by Vanda S. on 22/06/2022.
//

import UIKit

class PictureCell: UITableViewCell {
    
    static let identifier = "PictureCell"

    var documentImageView: UIImageView = {
        let documentImage = UIImageView()
        documentImage.translatesAutoresizingMaskIntoConstraints = false
        documentImage.backgroundColor = .systemPink
        return documentImage
    }()
    
    var documentName: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.systemFont(ofSize: 19)
        name.textColor = UIColor(named: "mainColor")!.withAlphaComponent(0.9)
        name.numberOfLines = 0
        name.minimumScaleFactor = 0.3
        name.adjustsFontSizeToFitWidth = true
        
        return name
    }()
    
    var dateLabel: UILabel = {
        let date = UILabel()
        date.text = "test"
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = UIFont.systemFont(ofSize: 13)
        date.textColor = .systemGray
        return date
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDocumentImage()
        setDocumentName()
        setDateLabel()
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
        
        documentImageView.contentMode = .scaleAspectFill
        documentImageView.clipsToBounds = true
    }
    
    func setDocumentName() {
        contentView.addSubview(documentName)

        documentName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        documentName.leftAnchor.constraint(equalTo: documentImageView.rightAnchor, constant: 20).isActive = true
        documentName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15).isActive = true
        
    }
    
    func setDateLabel() {
        contentView.addSubview(dateLabel)
       
        dateLabel.topAnchor.constraint(equalTo: documentName.bottomAnchor, constant: 10).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: documentImageView.rightAnchor, constant: 20).isActive = true
    }
    
    }
