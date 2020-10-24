//
//  Modals.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 24.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MoviesListResponse: Codable {
    var page: Int
    var totalResults: Int
    var totalPages: Int
    var results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page, totalResults="total_results", totalPages="total_pages", results
    }
}

class Movie: Codable {
    var id: Int
    var title: String
    var posterPath: String
    var backdropPath: String
    var voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, posterPath="poster_path", backdropPath="backdrop_path", voteCount="vote_count"
    }
    
    func addToFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard !isFavorited() else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteMovie", in: managedContext)!

        let favoriteMovie = NSManagedObject(entity: entity, insertInto: managedContext)
        favoriteMovie.setValue(id, forKeyPath: "id")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func removeFromFavorite() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard isFavorited() else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        let predicate = NSPredicate(format: "id = \(id)")
        fetchRequest.predicate = predicate

        do {
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for result in results {
                managedContext.delete(result)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func isFavorited() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        let predicate = NSPredicate(format: "id = \(id)")
        fetchRequest.predicate = predicate

        do {
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return results.count == 0 ? false : true
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
}
