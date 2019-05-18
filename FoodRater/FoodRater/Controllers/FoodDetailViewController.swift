//
//  FoodDetailViewController.swift
//  FoodRater
//
//  Created by Justin Herzog on 5/18/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit

class FoodDetailViewController: UIViewController {
    
    var foodName: String = ""
    var calories: String = ""
    var rating: String = ""
    var date: String = ""
    
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var caloriesAmountLabel: UILabel!
    
    @IBOutlet weak var ratingNumberLabel: UILabel!
    
    @IBOutlet weak var dateEatenDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foodNameLabel.text = foodName
        caloriesAmountLabel.text = calories
        ratingNumberLabel.text = rating
        dateEatenDateLabel.text = date
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
