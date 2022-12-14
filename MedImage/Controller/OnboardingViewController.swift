//
//  OnboardingViewController.swift
//  MedImage
//
//  Created by Vanda S. on 02/11/2022.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!

    @IBOutlet weak var onboardingPageControl: UIPageControl!
    
    var currentPage = 0 {
        didSet {
            onboardingPageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started".localized(), for: .normal)
                skipButton.isHidden = true
                nextButton.setTitleColor(UIColor(named: "mainReversed"), for: .normal)
                nextButton.backgroundColor = UIColor.systemPink
                nextButton.layer.cornerRadius = 10
              
            } else {
                nextButton.setTitle("Next".localized(), for: .normal)
                skipButton.isHidden = false
                nextButton.setTitleColor(.systemPink, for: .normal)
                nextButton.backgroundColor = .none
            }
        }
    }
    
    var slides: [OnboardingSlide] = [OnboardingSlide(title: "Welcome to MedImage!".localized(), description: "First, let us introduce you to the app and how to use it, step by step".localized(), image: UIImage(named: "Pink")), OnboardingSlide(title: "Starting up".localized(), description: "You can make custom folders just for your needs, to store different images in different spaces, named just the way you find it right".localized(), image: UIImage(named: "Screen1")!), OnboardingSlide(title: "Adding new images".localized(), description: "You can name, describe and set a date for each image you add, to properly store and organize your documents inside your folder".localized(), image: UIImage(named: "Screen3")!), OnboardingSlide(title: "Viewing your document".localized(), description: "You can change the description, rename your image, send it outside directly from the app and zoom in by clicking the image".localized(), image: UIImage(named: "Screen2"))]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.delegate = self

        setNextButton()
    }
  
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            UserDefaults.standard.hasOnboarded = true
            present(vc, animated: true)
            } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    func setNextButton() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        onboardingPageControl.currentPage = currentPage
    }
}
