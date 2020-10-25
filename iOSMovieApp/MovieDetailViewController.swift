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
    @IBOutlet weak var movieImageView: AsyncImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var movieDescriptionTextView: UITextView!
    
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieFavoriteButton.image = Constants.getFavoritedImage(favorited: movie?.isFavorited())
        
        if let backdropPath = movie?.backdropPath {
            movieImageView.urlStr = Constants.getMovieImageURL(with: backdropPath)
        }
        
        movieTitleLabel.text = movie?.title
        
        if let voteCount = movie?.voteCount {
            voteCountLabel.text = String(voteCount)
        }
        movieDescriptionTextView.text = movie?.overview
        
        movieFavoriteButton.action = #selector(favoriteMovieTap)
        movieFavoriteButton.target = self
    }
    
    @objc
    func favoriteMovieTap(sender: FavoriteUITapGestureRecognizer) {
        (movie?.isFavorited() ?? false) ? movie?.removeFromFavorite(): movie?.addToFavorite()
        movieFavoriteButton.image = Constants.getFavoritedImage(favorited: movie?.isFavorited())
    }

}
