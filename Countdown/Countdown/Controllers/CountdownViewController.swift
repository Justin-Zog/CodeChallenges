//
//  CountdownViewController.swift
//  Countdown
//
//  Created by Justin Herzog on 6/19/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    
    var seconds: Int = 10
    var timer: Timer = Timer()
    var isTimerRunning: Bool = false

    @IBOutlet weak var beginButton: UIButton!
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownLabel.accessibilityIdentifier = "countdownLabel"
        beginButton.accessibilityIdentifier = "beginButton"
        setDefaults()
    }
    
    func setDefaults() {
        timer.invalidate()
        isTimerRunning = false
        countdownLabel.text = "Ready"
        beginButton.setTitle("Begin", for: .normal)
        seconds = 10
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        beginButton.setTitle("Cancel", for: .normal)
        isTimerRunning = true
    }
    
    @objc func updateLabel() {
        countdownLabel.text = String(seconds)
        seconds -= 1
        if seconds < -1 {
            setDefaults()
        }
    }
    
    @IBAction func beginButtonTapped(_ sender: Any) {
        if !isTimerRunning {
            runTimer()
        } else {
            setDefaults()
        }
    }
}
