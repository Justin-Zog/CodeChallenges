//
//  FoodLogTableViewController.swift
//  FoodRater
//
//  Created by Justin Herzog on 5/17/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit
import CoreData

class FoodLogTableViewController: UITableViewController {
    
    var foodItems: [FoodItem] = []
    var selectedFoodName: String = ""
    var selectedCalories: String = ""
    var selectedRating: Int = 0
    var selectedDate: Date = Date()
    var dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFoodItems()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func updateFoodItems() {
        let request = NSFetchRequest < NSFetchRequestResult > (entityName: "FoodItem")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "calories") as! String)
                print(data.value(forKey: "dateConsumed") as! Date)
                print(data.value(forKey: "rating") as! Int16)
                print("Data group end")
                guard let castedResult = result as? [FoodItem] else {
                    print("Result cannot be converted to a FoodItem")
                    return
                }
                self.foodItems = castedResult
            }
        } catch {
            print("Failed to fetch data")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        cell.nameLabel.text = foodItems[indexPath.row].name
        cell.ratingLabel.text = String(foodItems[indexPath.row].rating)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrappedName = foodItems[indexPath.row].name,
            let unwrappedCalories = foodItems[indexPath.row].calories,
            let unwrappedDate = foodItems[indexPath.row].dateConsumed else { return }
        
        selectedFoodName = unwrappedName
        selectedCalories = unwrappedCalories
        selectedRating = Int(foodItems[indexPath.row].rating)
        selectedDate = unwrappedDate
        
        performSegue(withIdentifier: "toFoodDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dateFormat.dateStyle = .short
        if segue.identifier == "toFoodDetailView" {
            let foodDetailVC = segue.destination as? FoodDetailViewController
            foodDetailVC?.foodName = selectedFoodName
            foodDetailVC?.calories = selectedCalories
            foodDetailVC?.rating = String(selectedRating)
            foodDetailVC?.date = dateFormat.string(from: selectedDate)
        }
    }
    
    @IBAction func unwindFromTrackingVC(_ sender: UIStoryboardSegue) {
        
        if sender.source is TrackingViewController {
            if let trackingVC = sender.source as? TrackingViewController {
                let food = trackingVC.foodTextField.text
                let calories = trackingVC.caloriesTextField.text
                let date = trackingVC.datePicker.date
                let rating = Int(trackingVC.ratingStepper.value)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "FoodItem", in: context)
                let newFoodItem = NSManagedObject(entity: entity!, insertInto: context)
                
                newFoodItem.setValue("\(food!)", forKey: "name")
                newFoodItem.setValue("\(calories!)", forKey: "calories")
                newFoodItem.setValue(date, forKey: "dateConsumed")
                newFoodItem.setValue(rating, forKey: "rating")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
                updateFoodItems()
                tableView.reloadData()
            }
        }
    }
}
