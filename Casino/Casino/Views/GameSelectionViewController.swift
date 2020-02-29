//
//  GameSelectionViewController.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import UIKit

class GameSelectionViewController: UIViewController {

    @IBOutlet weak var cardLabel: UILabel!
    
    @IBOutlet weak var oddsLabel: UILabel!
    
    var deck = makeDeck()
    var card: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deck = shuffleDeck(deck: deck)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func drawCardButtonTapped(_ sender: Any) {
        (deck, card) = drawCard(deck: deck)
        cardLabel.text = card
        oddsLabel.text = ("\(suitOdds(deck: deck)![0]) \(suitOdds(deck: deck)![1]) \(suitOdds(deck: deck)![2]) \(suitOdds(deck: deck)![3])")
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
