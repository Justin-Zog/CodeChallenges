//
//  User.swift
//  Casino
//
//  Created by Justin Herzog on 2/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import Foundation

struct User {
    
    var email: String
    var uid: String
    var username: String
    // Set this bool to true when the user gets their free money, it should never change after that
    var receivedMoney: Bool
    // Following comments are starting values
    var whiteChip: Int = 1 // 32
    var redChip: Int = 5 // 16
    var blueChip: Int = 10 // 8
    var greenChip: Int = 25 // 4
    var blackChip: Int = 100 // 2
    var purpleChip: Int = 500 // 1
    var yellowChip: Int = 1000 // 0
    var pinkChip: Int = 5000 // 0
    var orangeChip: Int = 10000 // 0
    
}
