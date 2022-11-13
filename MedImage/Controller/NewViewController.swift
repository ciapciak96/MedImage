//
//  NewViewController.swift
//  MedImage
//
//  Created by Vanda S. on 28/06/2022.
//

import UIKit

class NewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dateFormatter = DateFormatter()
    var date: Date?
    var imgUUID: String?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        hideKeyboardWhenTapped()
        
        setImagePreview()
        setButtons()
        setLabels()
        setTextView()
        setTextField()
        setDateButtonAndLabel()
        setDatePicker()
        setTopLabel()
        
        self.titleTextField.delegate = self
        self.descriptionTextView.delegate = self
    }
    
    @IBAction func openCamera(_ sender: Any) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = false
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
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func saveImage(_ sender: Any) {
        let date = datePicker.date
       weak var vc = storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController") as? DocumentsViewController

        guard let title = titleTextField.text, !title.isEmpty else {
            let acTitle = UIAlertController(title: "No title!", message: "Please add a title and continue", preferredStyle: .alert)
            acTitle.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(acTitle, animated: true)
            return
        }
        guard let path = imgUUID else {
            let acTitle = UIAlertController(title: "No image!", message: "Please add an image and continue", preferredStyle: .alert)
            acTitle.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(acTitle, animated: true)
            return
        }
        let newImage = returnImage(date: date, timestamp: Date(), name: title, uuid: path, description: descriptionTextView.text, folder: Fetched.folder!)
        do {
           try context.save()
        } catch {
            print("Could not save")
        }
        let indexPath = IndexPath(row: 0, section: 0)

        vc?.documentsTableView = Fetched.globalTableView

        Fetched.filteredData.insert(newImage, at: 0)
        Fetched.pictures.insert(newImage, at: 0)
        Fetched.fetchImagesFromDisk(fileName: newImage.photo!) { image in
            Fetched.filteredPictures.insert(image, at: 0)
            Fetched.fetchedPictures.insert(image, at: 0)
        }

        vc?.documentsTableView.beginUpdates()
        vc?.documentsTableView.insertRows(at: [indexPath], with: .automatic)
        vc?.documentsTableView.endUpdates()
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray3 {
            textView.text = nil
            textView.textColor = UIColor(named: "mainColor")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description here"
            textView.textColor = UIColor.systemGray3
        }
    }

    func returnImage(date: Date, timestamp: Date, name: String, uuid: String, description: String, folder: Folder) -> Image {
        let img = Image(context: context)
        img.date = date
        img.timestamp = timestamp
        img.name = name
        img.photo = uuid
        img.text = description
        img.folder = folder
        return img
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = Fetched.getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        imagePreview.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgUUID = imageName
        dismiss(animated: true)
    }
    
    func setTopLabel() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topLabel.text = "Add new document"
        topLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        topLabel.textColor = .systemPink
        
        topLabel.bottomAnchor.constraint(equalTo: imagePreview.topAnchor, constant: -30).isActive = true
        topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        topLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
    }
    
    func setImagePreview() {
        imagePreview.translatesAutoresizingMaskIntoConstraints = false

        imagePreview.image = UIImage(systemName: "doc")?.withTintColor(.systemGray5, renderingMode: .alwaysOriginal)

        imagePreview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imagePreview.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6).isActive = true
        imagePreview.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.30).isActive = true
    }
  
    func setButtons() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        cameraButton.tintColor = UIColor(named: "mainColor")?.withAlphaComponent(0.6)
        cameraButton.layer.cornerRadius = 10
        cameraButton.backgroundColor = .systemGray5
        
        cameraButton.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 30).isActive = true
        cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        libraryButton.tintColor = UIColor(named: "mainColor")?.withAlphaComponent(0.6)
        libraryButton.layer.cornerRadius = 10
        libraryButton.backgroundColor = .systemGray5
        
        libraryButton.topAnchor.constraint(equalTo: imagePreview.bottomAnchor, constant: 30).isActive = true
        libraryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        saveButton.tintColor = .systemBackground
        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .systemPink

        saveButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 70).isActive = true
        saveButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = UIColor(named: "mainColor")

        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 60).isActive = true

        descriptionLabel.text = "Description (optional)"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        descriptionLabel.textColor = UIColor(named: "mainColor")
        
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 40).isActive = true
    }
    
    func setTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.placeholder = "Enter title here"
        titleTextField.backgroundColor = UIColor(named: "mainReversed")
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.masksToBounds = true
        titleTextField.layer.borderColor = UIColor.systemGray6.cgColor
        
        titleTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    func setTextView() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionTextView.text = "Enter description here"
        descriptionTextView.textColor = UIColor.systemGray3

        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.systemGray6.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.backgroundColor = UIColor(named: "mainReversed")

        descriptionTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setDateButtonAndLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.text = "Set date"
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dateLabel.textColor = UIColor(named: "mainColor")
        
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
        dateLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 60).isActive = true
    }
    
    func setDatePicker() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.date = midnightToday
        datePicker.maximumDate = midnightToday
        datePicker.datePickerMode = .date
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    //OBJ-C FUNCTIONS
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize.height + 20.0), right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}



extension UIViewController {
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
