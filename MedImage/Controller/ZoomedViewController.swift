//
//  ZoomedViewController.swift
//  MedImage
//
//  Created by Vanda S. on 13/11/2022.
//

import UIKit

class ZoomedViewController: UIViewController {
    
    var imageZoomedView: ImageZoomView!
    var zoomedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageZoomedView = ImageZoomView(frame: view.bounds)
        view.addSubview(imageZoomedView)
        
        setImageZoomedView()
        self.imageZoomedView.set(image: zoomedImage)
        
    }
    
    @IBAction func dismissScreen(_ sender: Any) {
        dismiss(animated: true)
    }
  
    func setImageZoomedView() {
        imageZoomedView.translatesAutoresizingMaskIntoConstraints = false
        
        imageZoomedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageZoomedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageZoomedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageZoomedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}
