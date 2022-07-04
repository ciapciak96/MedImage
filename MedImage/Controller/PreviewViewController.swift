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
    
    var sendButton: UIBarButtonItem?
    var renameButton: UIBarButtonItem?
    
    var previewImage: UIImage?
    var selectedImage: Image?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTapped()
        setDateLabel()
        setPreviewImageView()
        setDescriptionLabelandTextView()
        setTitleLabel()
        setBarButtons()
        registerForKeyboardNotifications()

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
    
    override func viewDidDisappear(_ animated: Bool) {
        selectedImage?.text = descriptionTextView.text
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setBarButtons() {
        renameButton = UIBarButtonItem(title: "Rename", style: .done, target: self, action: #selector(renameImage))
        sendButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePicture))
        navigationItem.rightBarButtonItems = [sendButton!, renameButton!]
    }
    
    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.text = selectedImage?.name
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        titleLabel.textColor = UIColor.systemPink
        titleLabel.numberOfLines = 0
    }
    
    func setPreviewImageView() {
        previewImageView.translatesAutoresizingMaskIntoConstraints = false

        previewImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
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
        
        dateLabel.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 30).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
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
        descriptionTextView.isEditable = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 18)
        descriptionTextView.textColor = UIColor(named: "mainColor")
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    }
    
    func renameConfirm(_ name: String) {
        selectedImage?.name = name
        titleLabel.text = name
        do {
          try context.save()
        } catch {
            print("Could not save new folder")
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    //OBJ-C FUNCTIONS
    
    @objc func renameImage() {
        let ac = UIAlertController(title: "Rename document", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let newName = UIAlertAction(title: "Rename", style: .default) { [weak ac, weak self] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.renameConfirm(name) }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(newName)
        
        present(ac, animated: true)
    }
    
    @objc func sharePicture() {
        guard let image = previewImageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 30, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}




