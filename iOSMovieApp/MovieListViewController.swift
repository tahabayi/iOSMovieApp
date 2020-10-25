//
//  ViewController.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 23.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController {
    
    enum CurrentView {
        case grid
        case list
    }
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var moviesChangeViewButton: UIBarButtonItem!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func moviesChangeViewTap(_ sender: UIBarButtonItem) {
        moviesChangeViewButton.isEnabled = false
        swapCurrentView()
        moviesChangeViewButton.isEnabled = true
    }
    
    @IBAction func loadMoreButtonTap(_ sender: UIButton) {
        loadMovies(page: moviePageWillLoad)
    }
    
    var currentView: CurrentView = .list {
        didSet {
            setView(to: currentView)
        }
    }
    let moviesCollectionEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let moviesCollectionInteritemSpacing = CGFloat(10)
    var moviesCollectionColumnNumber = CGFloat(1)
    var movieImageRatio = CGFloat(0.570)
    var moviePageWillLoad = 1
    var movieList = [Movie]() {
        didSet {
            filterMovies()
        }
    }
    var movieListFiltered = [Movie]() {
        didSet {
            refreshMoviesCollectionView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        loadMovies(page: moviePageWillLoad)
    }
    
    func swapCurrentView() {
        currentView = currentView == .grid ? .list : .grid
    }
    
    func setView(to newView: CurrentView) {
        if newView == .list {
            movieImageRatio = CGFloat(0.570)
            moviesCollectionColumnNumber = CGFloat(1)
            moviesChangeViewButton.image = UIImage(named: "view-grid")
        } else {
            movieImageRatio = CGFloat(1.5)
            moviesCollectionColumnNumber = CGFloat(2)
            moviesChangeViewButton.image = UIImage(named: "view-list")
        }
        refreshMoviesCollectionView()
    }
    
    func filterMovies() {
        DispatchQueue.main.async() {
            self.movieListFiltered = self.movieList.filter({ movie in
                guard let text = self.searchBar.text else { return true }
                guard text != "" else { return true }
                return movie.title.lowercased().contains(text.lowercased())
            })
        }
    }
    
    func refreshMoviesCollectionView() {
        DispatchQueue.main.async() {
            self.moviesCollectionView.reloadData()
            self.moviesCollectionView.layoutIfNeeded()
        }
    }
    
    func loadMovies(page: Int) {
        let getMoviesUrlStr = Constants.getMoviesListURL(page: page)
        guard let getMoviesUrl = URL(string: getMoviesUrlStr) else { return }
        DispatchQueue.main.async() {
            self.loadMoreButton.isEnabled = false
            self.moviesChangeViewButton.isEnabled = false
        }
        URLSession.shared.dataTask(with: getMoviesUrl) { data, response, error in
            DispatchQueue.main.async() {
                self.loadMoreButton.isEnabled = true
                self.moviesChangeViewButton.isEnabled = true
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil
                else { return }
            do {
                let decoder = JSONDecoder()
                let moviesListResponse = try decoder.decode(MoviesListResponse.self, from: data)
                self.movieList.append(contentsOf: moviesListResponse.results)
                self.refreshMoviesCollectionView()
                self.moviePageWillLoad += 1
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    @objc
    func favoriteMovieTap(sender: FavoriteUITapGestureRecognizer) {
        guard let movie = sender.movie else { return }
        sender.isFavorited ? movie.removeFromFavorite(): movie.addToFavorite()
        refreshMoviesCollectionView()
    }
    
    @objc
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
        resignFirstResponder()
    }

}

extension MovieListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieListFiltered.count
    }
    
    func configure(cell: MovieCollectionViewCell, for movie: Movie) {
        // set title
        cell.movieLabel.text = movie.title
        // set image
        let imageURLStr = currentView == .grid ? movie.posterPath : movie.backdropPath
        cell.movieImageView.downloaded(from: Constants.getMovieImageURL(with: imageURLStr))
        // set favorite button
        let isFavorited = movie.isFavorited()
        let imageName: FavoriteImageName = isFavorited ? .favorited : .unFavorited
        cell.movieFavoriteButton.setImage(UIImage(systemName: imageName.rawValue), for: .normal)
        let favoriteTapGestureRecognizer = FavoriteUITapGestureRecognizer(target: self, action: #selector(favoriteMovieTap))
        favoriteTapGestureRecognizer.movie = movie
        favoriteTapGestureRecognizer.isFavorited = isFavorited
        cell.movieFavoriteButton.addGestureRecognizer(favoriteTapGestureRecognizer)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movieListFiltered[indexPath.item]
        configure(cell: cell, for: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - moviesCollectionEdgeInsets.left - moviesCollectionEdgeInsets.right - moviesCollectionInteritemSpacing) / moviesCollectionColumnNumber
        let height = width * movieImageRatio
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return moviesCollectionEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return moviesCollectionInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.3, animations: {
            cell?.transform = .init(scaleX: 0.93, y: 0.95)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.5, animations: {
            cell?.transform = .identity
        })
    }
    
}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMovies()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

class FavoriteUITapGestureRecognizer: UITapGestureRecognizer {
    
    var movie: Movie?
    var isFavorited = false
    
}
