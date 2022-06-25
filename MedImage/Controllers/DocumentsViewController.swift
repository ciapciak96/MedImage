//
//  DocumentsViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit

class DocumentsViewController: UIViewController {

    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pictures = [Image]()
    var folder: Folder?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        searchBar.delegate = self
        
        documentsTableView.register(PictureCell.self, forCellReuseIdentifier: "PictureCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        
        setTableView()
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
        present(vc, animated: true)
    }
   
    
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = documentsTableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! PictureCell
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
    
}

extension DocumentsViewController: UISearchBarDelegate {
    
}
