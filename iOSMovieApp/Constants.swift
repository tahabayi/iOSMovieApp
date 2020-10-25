//
//  Constants.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 24.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    static let apiKey = "fd2b04342048fa2d5f728561866ad52a"
    static let moviesListURL = "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=\(apiKey)&page="
    static let movieImageURL = "https://image.tmdb.org/t/p/w500"
    
    static func getMoviesListURL(page: Int) -> String {
        return moviesListURL + String(page)
    }
    
    static func getMovieImageURL(with parameter: String) -> String {
        return movieImageURL + parameter
    }
    
    static func getFavoritedImage(favorited: Bool?) -> UIImage? {
        return UIImage(systemName: (favorited ?? false) ? "star.fill" : "star")
    }
    
}
