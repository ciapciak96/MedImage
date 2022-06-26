//
//  DocumentsViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit
import CoreData

class DocumentsViewController: UIViewController {

    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredPictures = []
        fetchedPictures = []
        
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.scopeButtonTitles = ["Date", "Name"]
        
        documentsTableView.register(PictureCell.self, forCellReuseIdentifier: "PictureCell")
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture)), UIBarButtonItem(title: "Sort by date", style: .done, target: self, action: #selector(sortByDate))]
        
        setTableView()
        
        DispatchQueue.global().async {
            for picture in pictures {
            fetchImagesFromDisk(fileName: picture.photo!) { image in
                fetchedPictures.append(image)
                filteredPictures.append(image)
                        
            }
        }
    }
        
    }
    
    
    func setTableView() {
        documentsTableView.translatesAutoresizingMaskIntoConstraints = false
        documentsTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        documentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        documentsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        documentsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        documentsTableView.backgroundColor = .clear
    }
  
    
    @objc func addPicture() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewImageViewController") as! NewImageViewController
        globalTableView = documentsTableView
        present(vc, animated: true)
    }
    
    @objc func sortByDate() {
        filteredPictures = []
       
        filteredData = filteredData.sorted(by: {
            $0.date!.compare($1.date!) == .orderedDescending })
        for date in filteredData {
            fetchImagesFromDisk(fileName: date.photo!) { image in
                filteredPictures.append(image)
            }
            
        }
        
        documentsTableView.reloadData()
}
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
        
        cell.documentImageView.image = filteredPictures[indexPath.row]
    
        
       // cell.documentImageView.image = pictures[indexPath.row].photo
        cell.documentName.text = filteredData[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.selectedImage = filteredData[indexPath.row]
        vc.title = filteredData[indexPath.row].name
       // vc.descriptionTextView.text = pictures[indexPath.row].text
        print(filteredData[indexPath.row].date)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    
}

extension DocumentsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        filteredPictures = []
        
        if searchText == "" {
            filteredData = pictures
            filteredPictures = fetchedPictures
        } else {
            for imageObject in pictures {
                if imageObject.name!.lowercased().starts(with: searchText.lowercased()) {
                    filteredData.append(imageObject)
                    fetchImagesFromDisk(fileName: imageObject.photo!) { [weak self] image in
                        filteredPictures.append(image)
                    }
                }
                
            }
            
        }
        self.documentsTableView.reloadData()
}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
