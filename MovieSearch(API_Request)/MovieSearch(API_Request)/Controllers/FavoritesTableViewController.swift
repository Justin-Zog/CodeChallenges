//
//  FavoritesTableViewController.swift
//  MovieSearch(API_Request)
//
//  Created by Justin Herzog on 5/20/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController {
    
    var favoriteMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFavoriteMovies()
        tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteMovies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteMovieCell", for: indexPath)
        
        cell.textLabel?.text = favoriteMovies[indexPath.row].name
        cell.detailTextLabel?.text = favoriteMovies[indexPath.row].type
        
        return cell
    }
    
    func updateFavoriteMovies() {
        let request = NSFetchRequest < NSFetchRequestResult > (entityName: "FavoritedMovie")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "title") as! String)
                print(data.value(forKey: "type") as! String)
                print("Data group end")
                guard let movieTitle = data.value(forKey: "title") as? String,
                    let movieType = data.value(forKey: "type") as? String else { return }
                let fetchedMovie = Movie(name: movieTitle, type: movieType)
                if !(favoriteMovies.contains(fetchedMovie)) {
                    self.favoriteMovies.append(Movie(name: movieTitle, type: movieType))
                }
            }
        } catch {
            print("Failed to fetch data")
        }
    }
}
