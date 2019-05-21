//
//  GameViewController.swift
//  RockPaperScissors
//
//  Created by Justin Herzog on 5/21/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var currentScore: Int = 0
    var highScore: Int = 0
    var usersNumber: Int = -1
    var compsNumber: Int = -1
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
    }
    
    func compChoose() {
        let setCompsNumber: Int = Int.random(in: 0...2)
        compsNumber = setCompsNumber
    }
    
    @IBAction func rockButtonTapped(_ sender: Any) {
        usersNumber = 0
        if usersNumber > -1 {
            playButton.isEnabled = true
        } else {
            playButton.isEnabled = true
        }
    }
    
    @IBAction func paperButtonTapped(_ sender: Any) {
        usersNumber = 1
        if usersNumber > -1 {
            playButton.isEnabled = true
        } else {
            playButton.isEnabled = true
        }
    }
    
    @IBAction func scissorsButtonTapped(_ sender: Any) {
        usersNumber = 2
        if usersNumber > -1 {
            playButton.isEnabled = true
        } else {
            playButton.isEnabled = true
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        compChoose()
        switch usersNumber {
        case 0:
            switch compsNumber {
            case 0:
                print("Tie")
            case 1:
                currentScore -= 1
            case 2:
                currentScore += 1
            default:
                print("Something went wrong")
            }
        case 1:
            switch compsNumber {
            case 0:
                currentScore += 1
            case 1:
                print("Tie")
            case 2:
                currentScore -= 1
            default:
                print("Something went wrong")
            }
        case 2:
            switch compsNumber {
            case 0:
                currentScore -= 1
            case 1:
                currentScore += 1
            case 2:
                print("Tie")
            default:
                print("Something went wrong")
            }
        default:
            print("User didn't choose button")
        }
        currentScoreLabel?.text = String("Current Score: \(currentScore)")
        usersNumber = -1
        playButton.isEnabled = false
    }
    
    
}
