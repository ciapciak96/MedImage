//
//  ViewController.swift
//  MedImage
//
//  Created by Vanda S. on 16/06/2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var folders = [Folder]()
    var trashButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?
    var editingStatus = false {
        didSet {
            if editingStatus == false {
                trashButton?.isEnabled = false
                addButton?.isEnabled = true
            } else {
                addButton?.isEnabled = false
            }
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setLayout()
        setAddButton()
        
        fetchFolders()
        
        navigationItem.leftBarButtonItem = editButtonItem

        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemPink]
    }
    
    func setAddButton() {
        trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteFolders))
        trashButton?.isEnabled = false
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFolder))
        navigationItem.rightBarButtonItems = [addButton!, trashButton!]
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
    
    func fetchObjectsFromFolder(folder: Folder) -> [Image] {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.predicate = NSPredicate(format: "folder = %@", folder)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        var fetched: [Image] = []
        do {
            fetched = try context.fetch(request)
        } catch {
            print("Could not fetch Images")
        }
        return fetched
    }
    
    @objc func addFolder() {
        let ac = UIAlertController(title: "Create new folder".localized(), message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let newName = UIAlertAction(title: "Add".localized(), style: .default) { [weak ac, weak self] _ in
            guard let name = ac?.textFields?[0].text else { return }
            self?.submit(name) }
        
        ac.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel))
        ac.addAction(newName)
        
        present(ac, animated: true)
    }
    
    @objc func deleteFolders() {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { $0.item }.sorted().reversed()
            for cell in items {
                let deletedFolder = folders[cell]
                folders.remove(at: cell)
                context.delete(deletedFolder)
                do {
                    try context.save()
                } catch {
                    print("Could not delete folders and save the changes")
                }
            }
            collectionView.deleteItems(at: selectedCells)
            guard let trashButton = trashButton else {
                return
            }
            trashButton.isEnabled = false
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editingStatus = editing
       
        collectionView.allowsMultipleSelection = editing
        collectionView.indexPathsForSelectedItems?.forEach({ (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        })
        collectionView.indexPathsForVisibleItems.forEach { (indexPath) in
            let cell = collectionView.cellForItem(at: indexPath) as! FolderCell
            cell.isInEditingMode = editing
            cell.backgroundColor = .cyan
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
        
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 10

        cell.layer.masksToBounds = false
        
        cell.isInEditingMode = isEditing

        cell.folderName.text = folders[indexPath.row].name
                                         
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let trashButton = trashButton else {
            return
        }
        
        if !isEditing {
                trashButton.isEnabled = false
        } else {
                trashButton.isEnabled = true
                if let cell = collectionView.cellForItem(at: indexPath) as? FolderCell {
                    cell.layer.shadowOpacity = 0
                    cell.backgroundColor = .systemGray4.withAlphaComponent(0.8)
                    }
                return
            }

        let vc = storyboard?.instantiateViewController(withIdentifier: "DocumentsViewController") as! DocumentsViewController
        vc.title = folders[indexPath.row].name
        
        Fetched.filteredData = fetchObjectsFromFolder(folder: folders[indexPath.row])
        Fetched.pictures = Fetched.filteredData
        Fetched.folder = folders[indexPath.row]

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            guard let trashButton = trashButton else {
                return
            }
            trashButton.isEnabled = false
        }
        if isEditing {
            if let cell = collectionView.cellForItem(at: indexPath) as? FolderCell {
                cell.backgroundColor = .systemGray6
                }
        }
    }
}
