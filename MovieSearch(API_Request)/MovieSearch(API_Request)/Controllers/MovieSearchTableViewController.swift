//
//  MovieSearchTableViewController.swift
//  MovieSearch(API_Request)
//
//  Created by Justin Herzog on 5/20/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit
import CoreData

class MovieSearchTableViewController: UITableViewController, UISearchBarDelegate {
    //My OMDb key b925edef
    var currentCellMovieTitle: String = ""
    var currentCellMovieType: String = ""
    
    let movieURL = URL(string: "http://www.omdbapi.com/?apikey=b925edef&s=")
    
    var movieArray: [Movie] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        
        var fetchedMovies: [Movie] = []
        
        guard let movieURL = movieURL else {
            print("Bad movieURL")
            return
        }
        
        guard let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "%20"),
            let searchURL = URL(string: "\(movieURL)\(searchText))") else {
                print("Bad URL after search term was added")
                return
        }
        
        let request = URLRequest(url: searchURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                do {
                    guard let data = data else { return }
                    let jsonObjects = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    guard let json = jsonObjects as? Dictionary<String, Any>,
                        let movies = json["Search"] else {
                            
                            let alert = UIAlertController(title: "There were no search results available for that search term", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                            print("Failed to access movies")
                            return
                    }
                    
                    guard let unwrappedMovies = movies as? [[String : String]] else {
                        print("Movies are screwed up")
                        return
                    }
                    
                    for movie in unwrappedMovies {
                        guard let title = movie["Title"],
                            let type = movie["Type"] else {
                                print("Wasn't able to get either movie title or movie type")
                                return
                        }
                        fetchedMovies.append(Movie(name: title, type: type))
                    }
                    completion(fetchedMovies)
                } catch {
                    print("Didn't initialize JSON")
                }
            }
        }
        task.resume()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        cell.textLabel?.text = movieArray[indexPath.row].name
        cell.detailTextLabel?.text = movieArray[indexPath.row].type
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveButton.isEnabled = true
        let currentCell = tableView.cellForRow(at: indexPath)
        guard let movieTitle = currentCell?.textLabel?.text,
            let movieType = currentCell?.detailTextLabel?.text else { return }
        currentCellMovieTitle = movieTitle
        currentCellMovieType = movieType
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        fetchMovies { (movies) in
            self.movieArray = movies
            self.tableView.reloadData()
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        print("Start Saving")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoritedMovie", in: context)
        let newFavoriteMovie = NSManagedObject(entity: entity!, insertInto: context)
        
        newFavoriteMovie.setValue("\(currentCellMovieTitle)", forKey: "title")
        newFavoriteMovie.setValue("\(currentCellMovieType)", forKey: "type")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        saveButton.isEnabled = false
    }
}
