//
//  TrackingViewController.swift
//  FoodRater
//
//  Created by Justin Herzog on 5/17/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit
import CoreData

class TrackingViewController: UIViewController, UITextFieldDelegate {
    
    let date = Date()
    
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var ratingStepper: UIStepper!
    
    @IBOutlet weak var foodTextField: UITextField!
    
    @IBOutlet weak var caloriesTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = date
        ratingLabel.text = String(Int(ratingStepper.value))
    }
    
    @IBAction func stepperButtonValueChanged(_ sender: Any) {
        ratingLabel.text = String(Int(ratingStepper.value))
    }
}
