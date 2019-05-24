//
//  GameViewController.swift
//  RockPaperScissors
//
//  Created by Justin Herzog on 5/21/19.
//  Copyright © 2019 Justin Herzog. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var lastPlayedArray: [Int] = []
    
    var wins: Int = 0
    var loses: Int = 0
    var ties: Int = 0
    var totalPlayed: Int = 0
    
    var currentScore: Int = 0
    var highScore: Int = 0
    var usersNumber: Int = -1
    var compsNumber: Int = -1
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var yourChoiceImage: UIImageView!
    
    @IBOutlet weak var compsChoiceImage: UIImageView!
    
    @IBOutlet weak var amountWonLabel: UILabel!
    
    @IBOutlet weak var amountTiedLabel: UILabel!
    
    @IBOutlet weak var amountLostLabel: UILabel!
    
    @IBOutlet weak var winPercentageLabel: UILabel!
    
    @IBOutlet weak var tiePercentageLabel: UILabel!
    
    @IBOutlet weak var losePercentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yourChoiceImage.image = nil
        compsChoiceImage.image = nil
        amountWonLabel.text = "Won:"
        amountTiedLabel.text = "Tied:"
        amountLostLabel.text = "Lost:"
        winPercentageLabel.text = "0%"
        tiePercentageLabel.text = "0%"
        losePercentageLabel.text = "0%"
    }
    
    func compChoose() {
        var rocks: Double = 0
        var papers: Double = 0
        var scissors: Double = 0
        
        for i in lastPlayedArray {
            if i == 0 {
                rocks += 1
            } else if i == 1 {
                papers += 1
            } else if i == 2 {
                scissors += 1
            }
        }
        
        if lastPlayedArray.count > 7  {
            let rockRatio = ((rocks / 23) * 100)
            let paperRatio = ((papers / 23) * 100)
            // let scissorsRatio = ((scissors / 23) * 100)
            let compsTempNumber: Double = Double.random(in: 1...100)
            
            if compsTempNumber <= rockRatio {
                compsNumber = 1
            } else if rockRatio...(rockRatio + paperRatio) ~= compsTempNumber {
                compsNumber = 2
            } else if (rockRatio + paperRatio)...100 ~= compsTempNumber {
                compsNumber = 0
            }
        } else if lastPlayedArray.count < 7 {
            let setCompsNumber: Int = Int.random(in: 0...2)
            compsNumber = setCompsNumber
        }
    }
    
    func changeScore() {
        compChoose()
        switch usersNumber {
        case 0:
            switch compsNumber {
            case 0:
                ties += 1
            case 1:
                currentScore -= 1
                loses += 1
            case 2:
                currentScore += 1
                wins += 1
            default:
                print("Something went wrong")
            }
        case 1:
            switch compsNumber {
            case 0:
                currentScore += 1
                wins += 1
            case 1:
                ties += 1
            case 2:
                currentScore -= 1
                loses += 1
            default:
                print("Something went wrong")
            }
        case 2:
            switch compsNumber {
            case 0:
                currentScore -= 1
                loses += 1
            case 1:
                currentScore += 1
                wins += 1
            case 2:
                ties += 1
            default:
                print("Something went wrong")
            }
        default:
            print("User didn't choose button")
        }
        totalPlayed += 1
        let percentWon: Double = round((Double(wins) / Double(totalPlayed)) * 100)
        let percentTied: Double = round((Double(ties) / Double(totalPlayed)) * 100)
        let percentLost: Double = round((Double(loses) / Double(totalPlayed)) * 100)
        currentScoreLabel?.text = String("Current Score: \(currentScore)")
        amountWonLabel.text = String("Won: \(wins)")
        amountTiedLabel.text = String("Tied: \(ties)")
        amountLostLabel.text = String("Lost: \(loses)")
        winPercentageLabel.text = String("\(percentWon)%")
        tiePercentageLabel.text = String("\(percentTied)%")
        losePercentageLabel.text = String("\(percentLost)%")
    }
    
    func updateLastPlayedArray() {
        if lastPlayedArray.count == 30 {
            lastPlayedArray.remove(at: 0)
            lastPlayedArray.append(usersNumber)
            usersNumber = -1
        } else if lastPlayedArray.count < 30 {
            lastPlayedArray.append(usersNumber)
            usersNumber = -1
        }
    }
    
    func setCompsImage() {
        if compsNumber == 0 {
            compsChoiceImage.image = UIImage(named: "Rock")
        } else if compsNumber == 1 {
            compsChoiceImage.image = UIImage(named: "Paper")
        } else if compsNumber == 2 {
            compsChoiceImage.image = UIImage(named: "Scissors")
        }
    }
    
    @IBAction func rockButtonTapped(_ sender: Any) {
        usersNumber = 0
        changeScore()
        updateLastPlayedArray()
        yourChoiceImage.image = UIImage(named: "Rock")
        setCompsImage()
    }
    
    @IBAction func paperButtonTapped(_ sender: Any) {
        usersNumber = 1
        changeScore()
        updateLastPlayedArray()
        yourChoiceImage.image = UIImage(named: "Paper")
        setCompsImage()
    }
    
    @IBAction func scissorsButtonTapped(_ sender: Any) {
        usersNumber = 2
        changeScore()
        updateLastPlayedArray()
        yourChoiceImage.image = UIImage(named: "Scissors")
        setCompsImage()
    }
}
