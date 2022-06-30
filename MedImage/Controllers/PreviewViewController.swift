//
//  PreviewViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var previewImage: UIImage?
    var selectedImage: Image?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setDateLabel()
        setPreviewImageView()
        setDescriptionLabelandTextView()
        setTitleLabel()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
        
        DispatchQueue.global().async {
            guard let selectedImage = self.selectedImage else {
                return
            }
            Fetched.fetchImagesFromDisk(fileName: (selectedImage.photo!)) {  image in
                DispatchQueue.main.async {
                    self.previewImageView.image = image
                }
            }
        }
    }
    
    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.text = selectedImage?.name
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        titleLabel.textColor = UIColor.systemPink
        titleLabel.numberOfLines = 0
    }
    
    func setPreviewImageView() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false

        previewImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        previewImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
  
    }
    
    func setDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        guard let selectedImage = selectedImage else {
            return
        }
        let date = dateFormatter.string(from: (selectedImage.date)!)
        dateLabel.text = date
        dateLabel.textColor = .systemGray
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        dateLabel.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 35).isActive = true
        
        
    }
    
    func setDescriptionLabelandTextView() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        descriptionLabel.textColor = UIColor(named: "mainColor")
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30).isActive = true
        
        descriptionTextView.text = selectedImage?.text
        descriptionTextView.isEditable = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 18)
        descriptionTextView.textColor = UIColor(named: "mainColor")
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        descriptionTextView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    @objc func sharePicture() {
        guard let image = previewImageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
