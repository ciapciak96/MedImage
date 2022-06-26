//
//  PreviewViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var previewImage: UIImage?
    var selectedImage: Image?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPreviewImageView()
        setDescriptionLabelandTextView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
        
        DispatchQueue.global().async {
            fetchImagesFromDisk(fileName: (self.selectedImage?.photo!)!) {  image in
                DispatchQueue.main.async {
                    self.previewImageView.image = image
                }
            }
        }

    }
    
    
    func setPreviewImageView() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        
        previewImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        previewImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setDescriptionLabelandTextView() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.textColor = .black
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 10).isActive = true
        
        descriptionTextView.text = selectedImage?.text
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.textColor = .black
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
    }
    
    @objc func sharePicture() {
        guard let image = previewImageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
