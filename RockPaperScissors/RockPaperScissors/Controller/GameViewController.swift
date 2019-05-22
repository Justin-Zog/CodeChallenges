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
    
    var totalCount: Double {
        return rockCount + paperCount + scissorsCount
    }
    var rockCount: Double = 0
    var paperCount: Double = 0
    var scissorsCount: Double = 0
    var currentScore: Int = 0
    var highScore: Int = 0
    var usersNumber: Int = -1
    var compsNumber: Int = -1
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var youWinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youWinLabel.isHidden = true
    }
    
    func compChoose() {
        if totalCount < 10 {
            let setCompsNumber: Int = Int.random(in: 0...2)
            compsNumber = setCompsNumber
        } else {
            let rockRatio = ((rockCount / totalCount) * 100)
            let paperRatio = ((paperCount / totalCount) * 100)
            // let scissorRatio = ((scissorsCount / totalCount) * 100)
            let compsTempNumber: Double = Double.random(in: 1...100)
            if compsTempNumber <= rockRatio {
                compsNumber = 1
            } else if rockRatio < compsTempNumber && compsTempNumber <= (rockRatio + paperRatio) {
                compsNumber = 2
            } else if (rockRatio + paperRatio) < compsTempNumber && compsTempNumber <= 100 {
                compsNumber = 0
            }
        }
    }
    
    func winLabelAnimation() {
        let scale = CGAffineTransform(scaleX: 5, y: 5)
        let unscale = CGAffineTransform(scaleX: 1/50, y: 1/50)
        youWinLabel.isHidden = false
        UIView.animate(withDuration: 0.33, animations: {
            self.youWinLabel.transform = scale
        }) { (true) in
            UIView.animate(withDuration: 0.33, animations: {
                self.youWinLabel.transform = unscale
            }) { (true) in
                self.youWinLabel.isHidden = true
            }
        }
    }
    
    func changeScore() {
        compChoose()
        switch usersNumber {
        case 0:
            switch compsNumber {
            case 0:
                youWinLabel.text = "You Tied"
                winLabelAnimation()
            case 1:
                youWinLabel.text = "You Lose"
                currentScore -= 1
                winLabelAnimation()
            case 2:
                youWinLabel.text = "You Win"
                currentScore += 1
                winLabelAnimation()
            default:
                print("Something went wrong")
            }
        case 1:
            switch compsNumber {
            case 0:
                youWinLabel.text = "You Win"
                currentScore += 1
                winLabelAnimation()
            case 1:
                youWinLabel.text = "You Tied"
                winLabelAnimation()
            case 2:
                youWinLabel.text = "You Lose"
                currentScore -= 1
                winLabelAnimation()
            default:
                print("Something went wrong")
            }
        case 2:
            switch compsNumber {
            case 0:
                youWinLabel.text = "You Lose"
                currentScore -= 1
                winLabelAnimation()
            case 1:
                youWinLabel.text = "You Win"
                currentScore += 1
                winLabelAnimation()
            case 2:
                youWinLabel.text = "You Tied"
                winLabelAnimation()
            default:
                print("Something went wrong")
            }
        default:
            print("User didn't choose button")
        }
        currentScoreLabel?.text = String("Current Score: \(currentScore)")
        usersNumber = -1
    }
    
    @IBAction func rockButtonTapped(_ sender: Any) {
        usersNumber = 0
        rockCount += 1
        changeScore()
        print(totalCount)
    }
    
    @IBAction func paperButtonTapped(_ sender: Any) {
        usersNumber = 1
        paperCount += 1
        changeScore()
        print(totalCount)
    }
    
    @IBAction func scissorsButtonTapped(_ sender: Any) {
        usersNumber = 2
        scissorsCount += 1
        changeScore()
        print(totalCount)
    }
}
