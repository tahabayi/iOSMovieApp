//
//  MovieDetailViewController.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 25.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
