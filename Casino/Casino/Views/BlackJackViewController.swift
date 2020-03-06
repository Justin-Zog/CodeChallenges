//
//  BlackJackViewController.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

// In blackjack the cards are dealt then the player plays the game, after all players (in this case one) have said stand the dealer flips over their face down card and must hit themselves until they are between 17-21 or bust.

// Playing cards are a width : height -> 1:1.4 ratio

import UIKit
import Firebase


class BlackJackViewController: UIViewController {
    
    @IBOutlet weak var hitMeButton: UIButton!
    
    @IBOutlet weak var playGameButton: UIButton!
    
    @IBOutlet weak var standButton: UIButton!
    
    @IBOutlet weak var youBetLabel: UILabel!
    
    @IBOutlet weak var dealersCardsView: UIStackView!
    
    @IBOutlet weak var playersCardsView: UIStackView!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var deck = makeDeck()
    var dealersCards: [String] = []
    var playersCards: [String] = []
    
    var username: String?
    var playersChips: [String: Int] = [:]
    var betChips: [String: Int] = [:]
    
    var playerScoreWithAceAsOne: Int = 0
    var playerScoreWithAceAsEleven: Int = 0
    var playerFinalScore: Int = 0
    var dealerScoreWithAceAsOne: Int = 0
    var dealerScoreWithAceAsEleven: Int = 0
    var dealerFinalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playGameButton.isHidden = false
        playGameButton.isEnabled = true
        hitMeButton.isHidden = true
        hitMeButton.isEnabled = false
        standButton.isHidden = true
        standButton.isEnabled = false
        youBetLabel.isHidden = true
        
        // Gets the user from firebase
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            let uid = user.uid
            self.ref.child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                guard let username = value?["username"] as? String else { print("Failed to get username"); return }
                self.username = username
                // Get the chips
                guard let whiteChips = value?["whiteChip"] as? String else { print("Failed to get whiteChips"); return }
                guard let redChips = value?["redChip"] as? String else { print("Failed to get the redChips"); return }
                guard let blueChips = value?["blueChip"] as? String else { print("Failed to get the blueChips"); return }
                guard let greenChips = value?["greenChip"] as? String else { print("Failed to get the greenChips"); return }
                guard let blackChips = value?["blackChip"] as? String else { print("Failed to get the blackChips"); return }
                guard let purpleChips = value?["purpleChip"] as? String else { print("Failed to get the purpleChips"); return }
                guard let yellowChips = value?["yellowChip"] as? String else { print("Failed to get the yellowChips"); return }
                guard let pinkChips = value?["pinkChip"] as? String else { print("Failed to get the pinkChips"); return }
                guard let orangeChips = value?["orangeChip"] as? String else { print("Failed to get the orangeChips"); return }
                // Adds chips to the playersChips dictionary
                self.playersChips["whiteChips"] = Int(whiteChips)
                self.playersChips["redChips"] = Int(redChips)
                self.playersChips["blueChips"] = Int(blueChips)
                self.playersChips["greenChips"] = Int(greenChips)
                self.playersChips["blackChips"] = Int(blackChips)
                self.playersChips["purpleChips"] = Int(purpleChips)
                self.playersChips["yellowChips"] = Int(yellowChips)
                self.playersChips["pinkChips"] = Int(pinkChips)
                self.playersChips["orangeChips"] = Int(orangeChips)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func dealCards() {
        // Shuffles the deck
        deck = shuffleDeck(deck: deck)
        // Deals the cards
        for i in 1...4 {
            // Draws a card
            let (newDeck, drawnCard) = drawCard(deck: deck)
            // Changes the deck to newDeck
            deck = newDeck
            if i % 2 != 0 {
                playersCards.append(drawnCard)
            } else {
                dealersCards.append(drawnCard)
            }
        }
        
        setCardImages()
        
        setPlayersScore()
        // If the players score is 21 (a blackjack) to start check the dealers hand and payout()
        if playerScoreWithAceAsOne == 21 || playerScoreWithAceAsEleven == 21 {
            setDealersScore()
            if dealerScoreWithAceAsOne == 21 || dealerScoreWithAceAsEleven == 21 {
                for chip in betChips {
                    // Gives the player chips their chips back
                    if chip.key == "whiteChips" {
                        guard var whiteChips = playersChips["whiteChips"] else { return }
                        whiteChips += 1
                        playersChips["whiteChips"] = whiteChips
                    } else if chip.key == "redChips" {
                        guard var redChips = playersChips["redChips"] else { return }
                        redChips += 1
                        playersChips["redChips"] = redChips
                    } else if chip.key == "blueChips" {
                        guard var blueChips = playersChips["blueChips"] else { return }
                        blueChips += 1
                        playersChips["blueChips"] = blueChips
                    } else if chip.key == "greenChips" {
                        guard var greenChips = playersChips["greenChips"] else { return }
                        greenChips += 1
                        playersChips["greenChips"] = greenChips
                    } else if chip.key == "blackChips" {
                        guard var blackChips = playersChips["blackChips"] else { return }
                        blackChips += 1
                        playersChips["blackChips"] = blackChips
                    } else if chip.key == "purpleChips" {
                        guard var purpleChips = playersChips["purpleChips"] else { return }
                        purpleChips += 1
                        playersChips["purpleChips"] = purpleChips
                    } else if chip.key == "yellowChips" {
                        guard var yellowChips = playersChips["yellowChips"] else { return }
                        yellowChips += 1
                        playersChips["yellowChips"] = yellowChips
                    } else if chip.key == "pinkChips" {
                        guard var pinkChips = playersChips["pinkChips"] else { return }
                        pinkChips += 1
                        playersChips["pinkChips"] = pinkChips
                    } else if chip.key == "orangeChips" {
                        guard var orangeChips = playersChips["orangeChips"] else { return }
                        orangeChips += 1
                        playersChips["orangeChips"] = orangeChips
                    }
                }
                
                // Resets the betChips
                betChips.removeAll()
                
            // The dealers hand isn't a blackjack
            } else {
                // Give the player what they bet times two back (2:1) ratio and what they bet
                for chip in betChips {
                    // Gives the player chips their chips back
                    if chip.key == "whiteChips" {
                        guard var whiteChips = playersChips["whiteChips"] else { return }
                        whiteChips += 3
                        playersChips["whiteChips"] = whiteChips
                    } else if chip.key == "redChips" {
                        guard var redChips = playersChips["redChips"] else { return }
                        redChips += 3
                        playersChips["redChips"] = redChips
                    } else if chip.key == "blueChips" {
                        guard var blueChips = playersChips["blueChips"] else { return }
                        blueChips += 3
                        playersChips["blueChips"] = blueChips
                    } else if chip.key == "greenChips" {
                        guard var greenChips = playersChips["greenChips"] else { return }
                        greenChips += 3
                        playersChips["greenChips"] = greenChips
                    } else if chip.key == "blackChips" {
                        guard var blackChips = playersChips["blackChips"] else { return }
                        blackChips += 3
                        playersChips["blackChips"] = blackChips
                    } else if chip.key == "purpleChips" {
                        guard var purpleChips = playersChips["purpleChips"] else { return }
                        purpleChips += 3
                        playersChips["purpleChips"] = purpleChips
                    } else if chip.key == "yellowChips" {
                        guard var yellowChips = playersChips["yellowChips"] else { return }
                        yellowChips += 3
                        playersChips["yellowChips"] = yellowChips
                    } else if chip.key == "pinkChips" {
                        guard var pinkChips = playersChips["pinkChips"] else { return }
                        pinkChips += 3
                        playersChips["pinkChips"] = pinkChips
                    } else if chip.key == "orangeChips" {
                        guard var orangeChips = playersChips["orangeChips"] else { return }
                        orangeChips += 3
                        playersChips["orangeChips"] = orangeChips
                    }
                }
                // Resets the betChips
                betChips.removeAll()
            }
            resetGraphics()
        }
    }
    
    //Sets the player's score
    func setPlayersScore() {
        var tempScoreWithAceAsOne: Int = 0
        var tempScoreWithAceAsEleven: Int = 0
        
        // Counts up the total of the players cards *** Remember an ace can be an eleven or a one and face cards are ten
        for card in playersCards {
            // Sets the number to the first character of the card... ex. "2D" becomes 2
            guard let number = Int(card.prefix(1)) else { print("The cards first character was not a number"); return }
            // Checks to see if the number is an ace
            if number == 1 {
                // Ace equals one
                tempScoreWithAceAsOne += 1
                // Ace equals eleven
                tempScoreWithAceAsEleven += 11
            } else if number > 10 {
                // Add ten to their score if it is a face card
                tempScoreWithAceAsOne += 10
                tempScoreWithAceAsEleven += 10
            } else {
                // Just add the number to the score because it is not a face card or an ace
                tempScoreWithAceAsOne += number
                tempScoreWithAceAsEleven += number
            }
        }
        // Sets the players score
        playerScoreWithAceAsOne = tempScoreWithAceAsOne
        playerScoreWithAceAsEleven = tempScoreWithAceAsEleven
    }
    
    // Sets the dealer's score
    func setDealersScore() {
        var tempScoreWithAceAsOne: Int = 0
        var tempScoreWithAceAsEleven: Int = 0
        
        for card in dealersCards {
            // Sets the number to the first character of the card... ex. "2D" becomes 2
            guard let number = Int(card.prefix(1)) else { print("The cards first character was not a number"); return }
            // Checks to see if the number is an ace
            if number == 1 {
                // Ace equals one
                tempScoreWithAceAsOne += 1
                // Ace equals eleven
                tempScoreWithAceAsEleven += 11
            } else if number > 10 {
                // Add ten to their score if it is a face card
                tempScoreWithAceAsOne += 10
                tempScoreWithAceAsEleven += 10
            } else {
                // Just add the number to the score because it is not a face card or an ace
                tempScoreWithAceAsOne += number
                tempScoreWithAceAsEleven += number
            }
        }
        // Sets the dealers score
        dealerScoreWithAceAsOne = tempScoreWithAceAsOne
        dealerScoreWithAceAsEleven = tempScoreWithAceAsEleven
    }
    
    func dealersLogic() {
        
        setDealersScore()
        
        // Goes through all possible combinations of the dealers hand
        // The dealers score is above 17 but less than 21 with their ace as an eleven, dealer holds
        if dealerScoreWithAceAsEleven >= 17 && dealerScoreWithAceAsEleven < 21 {
            // Check who wins, pay out, and reset graphics
            dealerFinalScore = dealerScoreWithAceAsEleven
            payOut()
            
        // The dealers score is less than 17, they must draw a card
        } else if dealerScoreWithAceAsOne < 17 && dealerScoreWithAceAsEleven < 17 {
            // Draws a card
            let (newDeck, drawnCard) = drawCard(deck: deck)
            // Changes the deck to newDeck (This is the main deck)
            deck = newDeck
            // Gives the player their card
            dealersCards.append(drawnCard)
            setCardImages()
            // Runs the function again to see if the dealer busts
            dealersLogic()
            
        // The dealers busts, if the player did not bust, they win
        } else if dealerScoreWithAceAsOne > 21 && dealerScoreWithAceAsEleven > 21 {
            // Payout should always go to the player here because if they did bust, dealers logic never gets run
            // Set the dealersScore as zero, that way any card beats it because the dealer busts
            dealerFinalScore = 0
            payOut()
            
        // The dealers score with the ace as an eleven is a bust, but the dealers score with the ace as a one is between 17 and 21
        } else if dealerScoreWithAceAsEleven > 21 && dealerScoreWithAceAsOne > 16 && dealerScoreWithAceAsOne < 22{
            // Check who wins, pay out, and reset graphics
            dealerFinalScore = dealerScoreWithAceAsOne
            payOut()
            
        // The dealers score with the ace as an eleven is a bust, but the dealers score with the ace as a one is not and also below 17, dealer must draw a card
        } else if dealerScoreWithAceAsEleven > 21 && dealerScoreWithAceAsOne < 17 {
            // Draws a card
            let (newDeck, drawnCard) = drawCard(deck: deck)
            // Changes the deck to newDeck (This is the main deck)
            deck = newDeck
            // Gives the player their card
            dealersCards.append(drawnCard)
            setCardImages()
            // Runs the function again to see if the dealer busts
            dealersLogic()
        }
    }
    
    // Sees if the dealer or player wins, then takes and gives chips accordingly
    func payOut() {
        if dealerFinalScore > playerFinalScore {
            // Take the players bet
            betChips.removeAll()
        } else if dealerFinalScore < playerFinalScore {
            // Give the player money
            for chip in betChips {
                // Gives the player chips their chips back
                if chip.key == "whiteChips" {
                    guard var whiteChips = playersChips["whiteChips"] else { return }
                    whiteChips += 2
                    playersChips["whiteChips"] = whiteChips
                } else if chip.key == "redChips" {
                    guard var redChips = playersChips["redChips"] else { return }
                    redChips += 2
                    playersChips["redChips"] = redChips
                } else if chip.key == "blueChips" {
                    guard var blueChips = playersChips["blueChips"] else { return }
                    blueChips += 2
                    playersChips["blueChips"] = blueChips
                } else if chip.key == "greenChips" {
                    guard var greenChips = playersChips["greenChips"] else { return }
                    greenChips += 2
                    playersChips["greenChips"] = greenChips
                } else if chip.key == "blackChips" {
                    guard var blackChips = playersChips["blackChips"] else { return }
                    blackChips += 2
                    playersChips["blackChips"] = blackChips
                } else if chip.key == "purpleChips" {
                    guard var purpleChips = playersChips["purpleChips"] else { return }
                    purpleChips += 2
                    playersChips["purpleChips"] = purpleChips
                } else if chip.key == "yellowChips" {
                    guard var yellowChips = playersChips["yellowChips"] else { return }
                    yellowChips += 2
                    playersChips["yellowChips"] = yellowChips
                } else if chip.key == "pinkChips" {
                    guard var pinkChips = playersChips["pinkChips"] else { return }
                    pinkChips += 2
                    playersChips["pinkChips"] = pinkChips
                } else if chip.key == "orangeChips" {
                    guard var orangeChips = playersChips["orangeChips"] else { return }
                    orangeChips += 2
                    playersChips["orangeChips"] = orangeChips
                }
            }
            
            // Resets the betChips
            betChips.removeAll()
        } else if dealerFinalScore == playerFinalScore {
            // Give the players bet back
            for chip in betChips {
                // Gives the player chips their chips back
                if chip.key == "whiteChips" {
                    guard var whiteChips = playersChips["whiteChips"] else { return }
                    whiteChips += 1
                    playersChips["whiteChips"] = whiteChips
                } else if chip.key == "redChips" {
                    guard var redChips = playersChips["redChips"] else { return }
                    redChips += 1
                    playersChips["redChips"] = redChips
                } else if chip.key == "blueChips" {
                    guard var blueChips = playersChips["blueChips"] else { return }
                    blueChips += 1
                    playersChips["blueChips"] = blueChips
                } else if chip.key == "greenChips" {
                    guard var greenChips = playersChips["greenChips"] else { return }
                    greenChips += 1
                    playersChips["greenChips"] = greenChips
                } else if chip.key == "blackChips" {
                    guard var blackChips = playersChips["blackChips"] else { return }
                    blackChips += 1
                    playersChips["blackChips"] = blackChips
                } else if chip.key == "purpleChips" {
                    guard var purpleChips = playersChips["purpleChips"] else { return }
                    purpleChips += 1
                    playersChips["purpleChips"] = purpleChips
                } else if chip.key == "yellowChips" {
                    guard var yellowChips = playersChips["yellowChips"] else { return }
                    yellowChips += 1
                    playersChips["yellowChips"] = yellowChips
                } else if chip.key == "pinkChips" {
                    guard var pinkChips = playersChips["pinkChips"] else { return }
                    pinkChips += 1
                    playersChips["pinkChips"] = pinkChips
                } else if chip.key == "orangeChips" {
                    guard var orangeChips = playersChips["orangeChips"] else { return }
                    orangeChips += 1
                    playersChips["orangeChips"] = orangeChips
                }
            }
            
            // Resets the betChips
            betChips.removeAll()
        }
        resetGraphics()
    }
    
    // Resets the graphics to the original view, this will be used when a player busts
    func resetGraphics() {
        playGameButton.isHidden = false
        playGameButton.isEnabled = true
        hitMeButton.isHidden = true
        hitMeButton.isEnabled = false
        standButton.isHidden = true
        standButton.isEnabled = false
        youBetLabel.isHidden = true
        // Removes all the cards from the stack view
        for view in playersCardsView.subviews {
            view.removeFromSuperview()
        }
        for view in dealersCardsView.subviews {
            view.removeFromSuperview()
        }
    }
    
    // Sets the images of the cards
    func setCardImages() {
        for card in playersCards {
            switch card {
            case "1D":
                let image = UIImage(named: "AceOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2D":
                let image = UIImage(named: "TwoOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3D":
                let image = UIImage(named: "ThreeOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4D":
                let image = UIImage(named: "FourOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5D":
                let image = UIImage(named: "FiveOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6D":
                let image = UIImage(named: "SixOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7D":
                let image = UIImage(named: "SevenOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8D":
                let image = UIImage(named: "EightOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9D":
                let image = UIImage(named: "NineOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10D":
                let image = UIImage(named: "TenOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11D":
                let image = UIImage(named: "JackOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12D":
                let image = UIImage(named: "QueenOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13D":
                let image = UIImage(named: "KingOfDiamonds")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "1H":
                let image = UIImage(named: "AceOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2H":
                let image = UIImage(named: "TwoOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3H":
                let image = UIImage(named: "ThreeOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4H":
                let image = UIImage(named: "FourOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5H":
                let image = UIImage(named: "FiveOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6H":
                let image = UIImage(named: "SixOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7H":
                let image = UIImage(named: "SevenOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8H":
                let image = UIImage(named: "EightOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9H":
                let image = UIImage(named: "NineOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10H":
                let image = UIImage(named: "TenOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11H":
                let image = UIImage(named: "JackOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12H":
                let image = UIImage(named: "QueenOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13H":
                let image = UIImage(named: "KingOfHearts")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "1S":
                let image = UIImage(named: "AceOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2S":
                let image = UIImage(named: "TwoOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3S":
                let image = UIImage(named: "ThreeOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4S":
                let image = UIImage(named: "FourOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5S":
                let image = UIImage(named: "FiveOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6S":
                let image = UIImage(named: "SixOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7S":
                let image = UIImage(named: "SevenOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8S":
                let image = UIImage(named: "EightOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9S":
                let image = UIImage(named: "NineOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10S":
                let image = UIImage(named: "TenOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11S":
                let image = UIImage(named: "JackOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12S":
                let image = UIImage(named: "QueenOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13S":
                let image = UIImage(named: "KingOfSpades")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "1C":
                let image = UIImage(named: "AceOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2C":
                let image = UIImage(named: "TwoOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3C":
                let image = UIImage(named: "ThreeOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4C":
                let image = UIImage(named: "FourOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5C":
                let image = UIImage(named: "FiveOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6C":
                let image = UIImage(named: "SixOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7C":
                let image = UIImage(named: "SevenOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8C":
                let image = UIImage(named: "EightOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9C":
                let image = UIImage(named: "NineOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10C":
                let image = UIImage(named: "TenOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11C":
                let image = UIImage(named: "JackOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12C":
                let image = UIImage(named: "QueenOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13C":
                let image = UIImage(named: "KingOfClubs")
                let imageView = UIImageView(image: image)
                playersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            default:
                break
            }
        }
        for card in dealersCards {
            switch card {
            case "1D":
                let image = UIImage(named: "AceOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2D":
                let image = UIImage(named: "TwoOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3D":
                let image = UIImage(named: "ThreeOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4D":
                let image = UIImage(named: "FourOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5D":
                let image = UIImage(named: "FiveOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6D":
                let image = UIImage(named: "SixOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7D":
                let image = UIImage(named: "SevenOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8D":
                let image = UIImage(named: "EightOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9D":
                let image = UIImage(named: "NineOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10D":
                let image = UIImage(named: "TenOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11D":
                let image = UIImage(named: "JackOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12D":
                let image = UIImage(named: "QueenOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13D":
                let image = UIImage(named: "KingOfDiamonds")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "1H":
                let image = UIImage(named: "AceOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2H":
                let image = UIImage(named: "TwoOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3H":
                let image = UIImage(named: "ThreeOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4H":
                let image = UIImage(named: "FourOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5H":
                let image = UIImage(named: "FiveOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6H":
                let image = UIImage(named: "SixOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7H":
                let image = UIImage(named: "SevenOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8H":
                let image = UIImage(named: "EightOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9H":
                let image = UIImage(named: "NineOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10H":
                let image = UIImage(named: "TenOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11H":
                let image = UIImage(named: "JackOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12H":
                let image = UIImage(named: "QueenOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13H":
                let image = UIImage(named: "KingOfHearts")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "1S":
                let image = UIImage(named: "AceOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2S":
                let image = UIImage(named: "TwoOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3S":
                let image = UIImage(named: "ThreeOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4S":
                let image = UIImage(named: "FourOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5S":
                let image = UIImage(named: "FiveOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6S":
                let image = UIImage(named: "SixOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7S":
                let image = UIImage(named: "SevenOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8S":
                let image = UIImage(named: "EightOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9S":
                let image = UIImage(named: "NineOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10S":
                let image = UIImage(named: "TenOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11S":
                let image = UIImage(named: "JackOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12S":
                let image = UIImage(named: "QueenOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13S":
                let image = UIImage(named: "KingOfSpades")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "1C":
                let image = UIImage(named: "AceOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "2C":
                let image = UIImage(named: "TwoOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "3C":
                let image = UIImage(named: "ThreeOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "4C":
                let image = UIImage(named: "FourOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "5C":
                let image = UIImage(named: "FiveOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "6C":
                let image = UIImage(named: "SixOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "7C":
                let image = UIImage(named: "SevenOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "8C":
                let image = UIImage(named: "EightOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "9C":
                let image = UIImage(named: "NineOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "10C":
                let image = UIImage(named: "TenOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "11C":
                let image = UIImage(named: "JackOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "12C":
                let image = UIImage(named: "QueenOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            case "13C":
                let image = UIImage(named: "KingOfClubs")
                let imageView = UIImageView(image: image)
                dealersCardsView.addSubview(imageView)
                imageView.frame = CGRect(x: 0, y: 0, width: ((playersCardsView.frame.height) * 10 / 28), height: (playersCardsView.frame.height / 2))
            default:
                print("Somehow not a card")
                break
            }
        }
    }
    
    // Call this function when the play button gets tapped, this will essentially start the game
    @IBAction func playGameButtonTapped(_ sender: Any) {
        // This function needs to ask for a bet and deal the cards out afterwards
        guard let username = username else { print("The username was not there"); return }
        let betAlert = UIAlertController(title: ("Welcome, " + username), message: "How many chips do you wish to bet?", preferredStyle: .alert)
        
        if playersChips["whiteChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["whiteChips"]!) white chips to bet")
            }
        }
        if playersChips["redChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["redChips"]!) red chips to bet")
            }
        }
        if playersChips["blueChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["blueChips"]!) blue chips to bet")
            }
        }
        if playersChips["greenChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["greenChips"]!) green chips to bet")
            }
        }
        if playersChips["blackChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["blackChips"]!) black chips to bet")
            }
        }
        if playersChips["purpleChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["purpleChips"]!) purple chips to bet")
            }
        }
        if playersChips["yellowChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["yellowChips"]!) yellow chips to bet")
            }
        }
        if playersChips["pinkChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["pinkChips"]!) pink chips to bet")
            }
        }
        if playersChips["orangeChips"] != 0 {
            betAlert.addTextField { (textField) in
                textField.placeholder = ("You have \(self.playersChips["orangeChips"]!) orange chips to bet")
            }
        }
        
        betAlert.addAction(UIAlertAction(title: "Bet!", style: .default, handler: { _ in
            
            var numWhiteChips = 0
            var numRedChips = 0
            var numBlueChips = 0
            var numGreenChips = 0
            var numBlackChips = 0
            var numPurpleChips = 0
            var numYellowChips = 0
            var numPinkChips = 0
            var numOrangeChips = 0
            
            // Get the chips they bet from the text field
            if self.playersChips["whiteChips"] != 0 {
                 guard let whiteChipsTextField = betAlert.textFields?[0], let whiteChips = whiteChipsTextField.text else { print("Failed to get whiteChips bet"); return }
                if let integerWhiteChips = Int(whiteChips) {
                    numWhiteChips = integerWhiteChips
                } else {
                    numWhiteChips = 0
                }
            }
            if self.playersChips["redChips"] != 0 {
                guard let redChipsTextField = betAlert.textFields?[1], let redChips = redChipsTextField.text else { print("Failed to get redChips bet"); return }
                if let integerRedChips = Int(redChips) {
                    numWhiteChips = integerRedChips
                } else {
                    numRedChips = 0
                }
            }
            if self.playersChips["blueChips"] != 0 {
                guard let blueChipsTextField = betAlert.textFields?[2], let blueChips = blueChipsTextField.text else { print("Failed to get blueChips bet"); return }
                if let integerBlueChips = Int(blueChips) {
                    numBlueChips = integerBlueChips
                } else {
                    numBlueChips = 0
                }
            }
            if self.playersChips["greenChips"] != 0 {
                guard let greenChipsTextField = betAlert.textFields?[3], let greenChips = greenChipsTextField.text else { print("Failed to get greenChips bet"); return }
                if let integerGreenChips = Int(greenChips) {
                    numGreenChips = integerGreenChips
                } else {
                    numGreenChips = 0

                }
            }
            if self.playersChips["blackChips"] != 0 {
                guard let blackChipsTextField = betAlert.textFields?[4], let blackChips = blackChipsTextField.text else { print("Failed to get blackChips bet"); return }
                if let integerBlackChips = Int(blackChips) {
                    numBlackChips = integerBlackChips
                } else {
                    numBlackChips = 0
                }
            }
            if self.playersChips["purpleChips"] != 0 {
                guard let purpleChipsTextField = betAlert.textFields?[5], let purpleChips = purpleChipsTextField.text else { print("Failed to get purpleChips bet"); return }
                if let integerPurpleChips = Int(purpleChips) {
                    numPurpleChips = integerPurpleChips
                } else {
                    numPurpleChips = 0
                }
            }
            if self.playersChips["yellowChips"] != 0 {
                guard let yellowChipsTextField = betAlert.textFields?[6], let yellowChips = yellowChipsTextField.text else { print("Failed to get yellowChips bet"); return }
                if let integerYellowChips = Int(yellowChips) {
                    numYellowChips = integerYellowChips
                } else {
                    numYellowChips = 0
                }
            }
            if self.playersChips["pinkChips"] != 0 {
                guard let pinkChipsTextField = betAlert.textFields?[7], let pinkChips = pinkChipsTextField.text else { print("Failed to get pinkChips bet"); return }
                if let integerPinkChips = Int(pinkChips) {
                    numPinkChips = integerPinkChips
                } else {
                    numPinkChips = 0
                }
            }
            if self.playersChips["orangeChips"] != 0 {
                guard let orangeChipsTextField = betAlert.textFields?[8], let orangeChips = orangeChipsTextField.text else { print("Failed to get orangeChips bet"); return }
                if let integerOrangeChips = Int(orangeChips) {
                    numOrangeChips = integerOrangeChips
                } else {
                    numOrangeChips = 0
                }
            }
            
            
            // Append the bet chips dictionary with the chips the user bet
            self.betChips["whiteChips"] = numWhiteChips
            self.betChips["redChips"] = numRedChips
            self.betChips["blueChips"] = numBlueChips
            self.betChips["greenChips"] = numGreenChips
            self.betChips["blackChips"] = numBlackChips
            self.betChips["purpleChips"] = numPurpleChips
            self.betChips["yellowChips"] = numYellowChips
            self.betChips["pinkChips"] = numPinkChips
            self.betChips["orangeChips"] = numOrangeChips
            
            // Get the amount of money they bet
            var betMoney: Int = 0
            if numWhiteChips != 0 {
                for _ in 1...numWhiteChips {
                    betMoney += 1
                }
            }
            if numRedChips != 0 {
                for _ in 1...numRedChips {
                    betMoney += 5
                }
            }
            if numBlueChips != 0 {
                for _ in 1...numBlueChips {
                    betMoney += 10
                }
            }
            if numGreenChips != 0 {
                for _ in 1...numGreenChips {
                    betMoney += 25
                }
            }
            if numBlackChips != 0 {
                for _ in 1...numBlackChips {
                    betMoney += 100
                }
            }
            if numPurpleChips != 0 {
                for _ in 1...numPurpleChips {
                    betMoney += 500
                }
            }
            if numYellowChips != 0 {
                for _ in 1...numYellowChips {
                    betMoney += 1000
                }
            }
            if numPinkChips != 0 {
                for _ in 1...numPinkChips {
                    betMoney += 5000
                }
            }
            if numOrangeChips != 0 {
                for _ in 0...numOrangeChips {
                    betMoney += 10000
                }
            }
            
            self.youBetLabel.text = ("You bet \(betMoney) dollars")
            self.youBetLabel.isHidden = false
            
            // Lastly disable the playGame button and hide it
            self.playGameButton.isHidden = true
            self.playGameButton.isEnabled = false
            self.hitMeButton.isHidden = false
            self.hitMeButton.isEnabled = true
            self.standButton.isHidden = false
            self.standButton.isEnabled = true
            
            // Deal the cards out
            self.dealCards()
        }))
        
        betAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the alert controller
        self.present(betAlert, animated: true, completion: nil)
    }
    
    // Deal a card to the play and check if they bust or not
    @IBAction func hitMeTapped(_ sender: Any) {
        
        // Draws a card
        let (newDeck, drawnCard) = drawCard(deck: deck)
        // Changes the deck to newDeck (This is the main deck)
        deck = newDeck
        // Gives the player their card
        playersCards.append(drawnCard)
        setCardImages()
        // Sets the players score
        setPlayersScore()
        
        // The game ends only if the player's hand is above 21
        // The player busts, game ends
        if playerScoreWithAceAsOne > 21 && playerScoreWithAceAsEleven > 21 {
            // Make an animation that says they bust, take their chips, and reset the game
            let bustAlert = UIAlertController(title: "Oh no!", message: "It looks like you bust with a score of \(playerScoreWithAceAsOne)", preferredStyle: .alert)
            
            bustAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            betChips.removeAll()
            
            resetGraphics()
        }
        
        
    }
    
    // This means that it is now the dealers turn, code the logic for the dealer in here
    @IBAction func standTapped(_ sender: Any) {
        
        // Set the players final score then run dealersLogic()
        // The player cannot have a bust in here
        // If the playerScoreWithAceAsEleven is less than 21 so will playerScoreWithAceAsOne
        if playerScoreWithAceAsEleven < 22 {
            playerFinalScore = playerScoreWithAceAsEleven
            
        // The playerScoreWithAceAsEleven is above 21 so playerScoreWithAceAsOne cannot be over 21
        } else if playerScoreWithAceAsEleven > 21 {
            playerFinalScore = playerScoreWithAceAsOne
        }
        
        dealersLogic()
        
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
