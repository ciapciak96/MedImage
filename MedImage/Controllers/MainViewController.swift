//
//  ViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var folders = [Folder]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setLayout()
        setAddButton()
        
        fetchFolders()
    }
    
    
    
    func setAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    func setLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 1
        
        layout.itemSize = CGSize(width: view.frame.size.width/3, height: (view.frame.size.width/2)-20)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.collectionViewLayout = layout
        collectionView.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
    }
    
    func submit(_ name: String) {
        let newFolder = Folder(context: context)
        newFolder.name = name
        folders.insert(newFolder, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        do {
          try context.save()
            print("Folder saved")
        } catch {
            print("Could not save new folder")
        }
        collectionView.reloadData()
    }
    
    func fetchFolders() {
        do {
            let reversed = try context.fetch(Folder.fetchRequest())
            self.folders = reversed.reversed()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("Could not fetch folders")
        }
    }
    
    @objc func addFolder() {
        let ac = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let newName = UIAlertAction(title: "Add", style: .default) { [weak ac, weak self] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.submit(name) }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(newName)
        
        present(ac, animated: true)
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 10
        
        cell.layer.shadowRadius = 20
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowColor = UIColor.systemGray.cgColor
        cell.layer.shadowOpacity = 0.3
        
        cell.layer.masksToBounds = false
        
        cell.folderName.text = folders[indexPath.row].name
                                         
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        vc.title = folders[indexPath.row].name
        if let allPictures = folders[indexPath.row].pictures?.allObjects as? [Image] {
            vc.folder = folders[indexPath.row]
            vc.pictures = allPictures
            print(allPictures.count)
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
}
