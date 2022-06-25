//
//  NewImageViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit

class NewImageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    let dateFormatter = DateFormatter()
    var date: Date?
    let datePicker = UIDatePicker()
    var imgUUID: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImagePreview()
        setButtons()
        setLabels()
        setTextView()
        setTextField()
        setDateButtonAndLabel()
        setDatePicker()
    }

    @IBAction func openCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let ac = UIAlertController(title: "No camera found", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveImage(_ sender: Any) {
        let dateString = dateFormatter.string(from: datePicker.date)
        let date = datePicker.date
        print(dateString)
        print(imgUUID)
        weak var vc = storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        guard let title = titleTextField.text, !title.isEmpty else {
            let acTitle = UIAlertController(title: "No title!", message: "Please add a title and continue", preferredStyle: .alert)
            acTitle.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(acTitle, animated: true)
            return
        }
        guard let path = imgUUID else {
            return
        }
        let newImage = returnImage(date: date, name: title, uuid: path, description: descriptionTextView.text)
        vc?.pictures.insert(newImage, at: 0)
        
    }
    
    func returnImage(date: Date, name: String, uuid: String, description: String) -> Image {
        let img = Image(context: context)
        img.date = date
        img.name = name
        img.photo = uuid
        img.text = description
        return img
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        imagePreview.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imgUUID = imagePath.absoluteString
        dismiss(animated: true)
    }
    
    func setImagePreview() {
        imagePreview.translatesAutoresizingMaskIntoConstraints = false
        
        imagePreview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imagePreview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        imagePreview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        imagePreview.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50).isActive = true
        
        imagePreview.backgroundColor = .systemPink
    }
    
    func setButtons() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        cameraButton.setTitle("Take a picture", for: .normal)
        cameraButton.tintColor = .black
        cameraButton.layer.cornerRadius = 10
        cameraButton.backgroundColor = .systemBackground
        
        cameraButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        cameraButton.layer.shadowRadius = 5
        cameraButton.layer.shadowColor = UIColor.systemGray.cgColor
        cameraButton.layer.shadowOpacity = 0.3
        cameraButton.layer.masksToBounds = false
        
        cameraButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cameraButton.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 20).isActive = true
        cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        libraryButton.setTitle("Add from library", for: .normal)
        libraryButton.tintColor = .black
        libraryButton.layer.cornerRadius = 10
        libraryButton.backgroundColor = .systemBackground
        
        libraryButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        libraryButton.layer.shadowRadius = 5
        libraryButton.layer.shadowColor = UIColor.systemGray.cgColor
        libraryButton.layer.shadowOpacity = 0.3
        libraryButton.layer.masksToBounds = false
        
        libraryButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        libraryButton.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 20).isActive = true
        libraryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
//        saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 30).isActive = true
//        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
//        saveButton.
    }
    
    func setLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 40).isActive = true
        
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25).isActive = true
    }
    
    func setTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setTextView() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray6.cgColor

        
        descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setDateButtonAndLabel() {
      
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.text = "Set date"
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .black
        
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        dateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20).isActive = true
    }
    
    func setDatePicker() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.date = midnightToday
        view.addSubview(datePicker)
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 25).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    

    
}
