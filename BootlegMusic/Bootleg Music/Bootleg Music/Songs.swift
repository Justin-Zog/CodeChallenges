//
//  Songs.swift
//  Bootleg Music
//
//  Created by Justin Herzog on 1/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import UIKit

class Song {
    let name: String
    let artist: String
    let filePath: URL
    
    init(_ name: String, _ artist: String, _ filePath: URL) {
        self.name = name
        self.artist = artist
        self.filePath = filePath
    }
}
    
