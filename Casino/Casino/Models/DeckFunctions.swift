//
//  DeckFunctions.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

// This file will make a deck of cards as well as include functions that can be used on the deck
import Foundation


// Makes a deck
func makeDeck() -> [String] {
    var deck: [String] = []
    // Creates four cards of each suit
    for i in 1...13 {
        deck.append("\(i)D")
        deck.append("\(i)H")
        deck.append("\(i)S")
        deck.append("\(i)C")
    }
      
    return deck
}


// Shuffles a deck
func shuffleDeck(deck: [String]) -> [String] {
    // Makes a shuffled deck and returns the shuffled deck
    let shuffledDeck = deck.shuffled()
    return shuffledDeck
}


// Draws a card and removes it from the deck
func drawCard(deck: [String]) -> ([String], String) {
    var deck = deck
    // Makes a new deck and shuffles it if the current deck has zero cards
    if deck.count <= 0 {
        deck = makeDeck()
        deck = shuffleDeck(deck: deck)
    }
    // Unwraps to make sure a card exists
    guard let card = deck.first else {
        print("There were no cards in the deck")
        // This should never get called because we make a new deck if all the cards are gone
        // It just returns the five of clubs if this happens even tho it shouldn't
        return (deck, "5C")
    }
    // Remove the card we drew from the deck
    deck.removeFirst()
    
    return (deck, card)
}


// Returns the odds of the top card being a certain suit
func suitOdds(deck: [String]) -> [String]? {
    var deck = deck
    var odds: [String] = []
    var totalCards: Double = 0
    var diamonds: Double = 0
    var hearts: Double = 0
    var spades: Double = 0
    var clubs: Double = 0
    
    // Makes a new deck and shuffles it if the current deck has zero cards
    if deck.count <= 0 {
        deck = makeDeck()
        deck = shuffleDeck(deck: deck)
    }
    
    // This is the same as a for in statement except that the element in *** for element in range *** becomes $0
    // Checks to see how many of each suit is in the deck
    deck.forEach {
        if $0.contains("D") {
            diamonds += 1
            totalCards += 1
        } else if $0.contains("H") {
            hearts += 1
            totalCards += 1
        } else if $0.contains("S") {
            spades += 1
            totalCards += 1
        } else if $0.contains("C") {
            clubs += 1
            totalCards += 1
        } else {
            print("This means the card had no suit, this should never get called.")
        }
    }
    
    // Appends the odds array with the odds, it will look like [%Diamonds a diamond, %Hearts a heart, %Spades a spade, %Clubs a club]
    if totalCards != 0 {
        // We multiply by 10,000 then divide by 100 so we get a number rounded to 2 decimal places
        let percentDiamonds = (round((diamonds / totalCards) * 10000) / 100)
        let percentHearts = (round((hearts / totalCards) * 10000) / 100)
        let percentSpades = (round((spades / totalCards) * 10000) / 100)
        let percentClubs = (round((clubs / totalCards) * 10000) / 100)
        odds.append("%\(percentDiamonds) a diamond")
        odds.append("%\(percentHearts) a heart")
        odds.append("%\(percentSpades) a spade")
        odds.append("%\(percentClubs) a club")
    }
    
    // Checks to see if odds is empty and returns it if it is not
    if odds.isEmpty {
        print("suit odds was empty for some reason")
        return nil
    } else {
        return odds
    }
}


// Returns the odds of the top card being a certain number
func numberOdds(deck: [String]) -> [String]? {
    var deck = deck
    var odds: [String] = []
    var totalCards: Double = 0
    var aces: Double = 0
    var twos: Double = 0
    var threes: Double = 0
    var fours: Double = 0
    var fives: Double = 0
    var sixes: Double = 0
    var sevens: Double = 0
    var eights: Double = 0
    var nines: Double = 0
    var tens: Double = 0
    var jacks: Double = 0
    var queens: Double = 0
    var kings: Double = 0
    
    // Makes a new deck and shuffles it if the current deck has zero cards
    if deck.count <= 0 {
        deck = makeDeck()
        deck = shuffleDeck(deck: deck)
    }
    
    // This is the same as a for in statement except that the element in *** for element in range *** becomes $0
    // Checks to see how many of each number are in the deck
    deck.forEach {
        if $0.contains("1") {
            aces += 1
            totalCards += 1
        } else if $0.contains("2") {
            twos += 1
            totalCards += 1
        } else if $0.contains("3") {
            threes += 1
            totalCards += 1
        } else if $0.contains("4") {
            fours += 1
            totalCards += 1
        } else if $0.contains("5") {
            fives += 1
            totalCards += 1
        } else if $0.contains("6") {
            sixes += 1
            totalCards += 1
        } else if $0.contains("7") {
            sevens += 1
            totalCards += 1
        } else if $0.contains("8") {
            eights += 1
            totalCards += 1
        } else if $0.contains("9") {
            nines += 1
            totalCards += 1
        } else if $0.contains("10") {
            tens += 1
            totalCards += 1
        } else if $0.contains("11") {
            jacks += 1
            totalCards += 1
        } else if $0.contains("12") {
            queens += 1
            totalCards += 1
        } else if $0.contains("13") {
            kings += 1
            totalCards += 1
        } else {
            print("This means the card has no number, this should never get called")
        }
    }
    
    // Appends the odds array with the odds
    if totalCards != 0 {
        odds.append("%\(aces / totalCards) an ace")
        odds.append("%\(twos / totalCards) a two")
        odds.append("%\(threes / totalCards) a three")
        odds.append("%\(fours / totalCards) a four")
        odds.append("%\(fives / totalCards) a fives")
        odds.append("%\(sixes / totalCards) a six")
        odds.append("%\(sevens / totalCards) a seven")
        odds.append("%\(eights / totalCards) an eight")
        odds.append("%\(nines / totalCards) a nine")
        odds.append("%\(tens / totalCards) a ten")
        odds.append("%\(jacks / totalCards) a jack")
        odds.append("%\(queens / totalCards) a queen")
        odds.append("%\(kings / totalCards) a king")
    }
    
    // Checks to see if odds is empty and returns it if it is not
    if odds.isEmpty {
        print("card odds was empty for some reason")
        return nil
    } else {
        return odds
    }
}
