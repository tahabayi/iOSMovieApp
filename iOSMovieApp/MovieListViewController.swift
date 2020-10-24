//
//  ViewController.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 23.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var moviesChangeViewButton: UIBarButtonItem!
    
    @IBAction func moviesChangeViewTap(_ sender: UIBarButtonItem) {
        moviesChangeViewButton.isEnabled = false
        swapCurrentView()
        moviesChangeViewButton.isEnabled = true
    }
    
    var currentView = "list" {
        didSet {
            setView(viewLabel: currentView)
        }
    }
    let moviesCollectionEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let moviesCollectionInteritemSpacing = CGFloat(10)
    var moviesCollectionColumnNumber = CGFloat(1)
    var ratio = CGFloat(0.570)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func swapCurrentView() {
        currentView = currentView == "grid" ? "list" : "grid"
    }
    
    func setView(viewLabel: String) {
        if viewLabel == "list" {
            ratio = CGFloat(0.570)
            moviesCollectionColumnNumber = CGFloat(1)
            moviesCollectionView.reloadData()
            moviesCollectionView.layoutIfNeeded()
            moviesChangeViewButton.image = UIImage(named: "view-grid")
        } else {
            ratio = CGFloat(1.5)
            moviesCollectionColumnNumber = CGFloat(2)
            moviesCollectionView.reloadData()
            moviesCollectionView.layoutIfNeeded()
            moviesChangeViewButton.image = UIImage(named: "view-list")
        }
    }

}

extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - moviesCollectionEdgeInsets.left - moviesCollectionEdgeInsets.right - moviesCollectionInteritemSpacing) / moviesCollectionColumnNumber
        let height = width * ratio
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return moviesCollectionEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return moviesCollectionInteritemSpacing
    }
    
}
