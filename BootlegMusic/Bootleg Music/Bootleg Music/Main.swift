//
//  Main.swift
//  Bootleg Music
//
//  Created by Justin Herzog on 1/29/20.
//  Copyright © 2020 Justin Herzog. All rights reserved.
//

import UIKit
import AVFoundation

class Main: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var songTimerSlider: UISlider!
    
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var lowerControlPanelView: UIView!
    
    @IBOutlet weak var shuffleButton: UIButton!
    
    // List of songs &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    var mrHeartache: Song = Song("Mr. Heartache", "Sekai No Owari", URL(fileURLWithPath: Bundle.main.path(forResource: "MrHeartache", ofType: "mp3")!))
    var antiHero: Song = Song("Anti-Hero", "Sekai No Owari", URL(fileURLWithPath: Bundle.main.path(forResource: "AntiHero", ofType: "mp3")!))
    var loveSong: Song = Song("Love Song", "Sekai No Owari", URL(fileURLWithPath: Bundle.main.path(forResource: "LoveSong", ofType: "mp3")!))
    var dragonNight: Song = Song("Dragon Night", "Sekai No Owari", URL(fileURLWithPath: Bundle.main.path(forResource: "DragonNight", ofType: "mp3")!))
    var heyHo: Song = Song("Hey Ho", "Sekai No Owari", URL(fileURLWithPath: Bundle.main.path(forResource: "HeyHo", ofType: "mp3")!))
    var starlightParade: Song = Song("Starlight Parade", "Sekai No Owari", URL(fileURLWithPath: Bundle.main.path(forResource: "StarlightParade", ofType: "mp3")!))
    var theTaleOfMrMorton: Song = Song("The Tale Of Mr. Morton", "Skee-Lo", URL(fileURLWithPath: Bundle.main.path(forResource: "TheTaleOfMrMorton", ofType: "mp3")!))
    var aGhostsPumpkinSoup: Song = Song("A Ghost's Pumpkin Soup", "Hunnid-P", URL(fileURLWithPath: Bundle.main.path(forResource: "AGhost'sPumpkinSoup", ofType: "mp3")!))
    var zenZenZenSe: Song = Song("前前前世 (Zenzenzense)", "RADWIMPS", URL(fileURLWithPath: Bundle.main.path(forResource: "zenzenzense", ofType: "mp3")!))
    // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    
    var audioPlayer: AVAudioPlayer?
    
    var paused: Bool = false
    
    var counter: Int = 0
    
    var isShuffled = false
    
    var songs: [Song] = []
    
    var shuffledSongs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Makes it so the phone plays music in silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        //
        songTimerSlider.isContinuous = false
        paused = false
        songTimerSlider.value = 0
        timerView.backgroundColor = UIColor.darkGray
        lowerControlPanelView.backgroundColor = UIColor.darkGray
        self.view.backgroundColor = UIColor.darkGray
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        mainTableView.backgroundColor = UIColor.darkGray
        songs.append(contentsOf: [mrHeartache, theTaleOfMrMorton, antiHero, loveSong, dragonNight, heyHo, starlightParade, aGhostsPumpkinSoup, zenZenZenSe])
        sortByName()
        // Do any additional setup here
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Your number of cells here
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Coding for the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        cell.backgroundColor = UIColor.darkGray
        cell.songNameLabel.textColor = UIColor.lightGray
        cell.artistNameLabel.textColor = UIColor.lightGray
        cell.songNameLabel.text = songs[indexPath.row].name
        cell.artistNameLabel.text = songs[indexPath.row].artist
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // What happens when a cell is selected
        counter = indexPath.row
        // Plays the song
        playSong()
    }
    
    func playSong() {
        // Tries to get the song
        isShuffled = false
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: songs[counter].filePath)
        } catch let error {
            print("Can't play the audio file, failed with error \(error.localizedDescription)")
        }
        // Starts the timer
        songTimerSlider.maximumValue = Float(audioPlayer!.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector(("updateSongTimer")), userInfo: nil, repeats: true)
        audioPlayer!.delegate = self
        // Plays the song
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    func playShuffledSongs() {
        // Tries to get the song
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: shuffledSongs[counter].filePath)
        } catch let error {
            print("Can't play the audio file, failed with error \(error.localizedDescription)")
        }
        // Starts the timer
        songTimerSlider.maximumValue = Float(audioPlayer!.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: Selector(("updateSongTimer")), userInfo: nil, repeats: true)
        audioPlayer!.delegate = self
        // Plays the song
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Called")
        
        if flag == true {
            counter += 1
        }
        
        if (counter == songs.count || counter > songs.count) {
            counter = 0
        }
        
        if isShuffled == false {
            playSong()
        } else {
            playShuffledSongs()
        }
    }
    
    @objc func updateSongTimer() {
        songTimerSlider.value = Float(audioPlayer!.currentTime)
    }
    
    func sortByName() {
        let sortedSongs = songs.sorted { $0.name < $1.name }
        songs = sortedSongs
        mainTableView.reloadData()
    }
    
    func shuffle() {
        
    }
    
    @IBAction func sortByAlphabeticalOrderButtonTapped(_ sender: Any) {
        sortByName()
    }
    
    @IBAction func sortByArtistTapped(_ sender: Any) {
        let sortedSongs = songs.sorted { $0.artist < $1.artist }
        songs = sortedSongs
        mainTableView.reloadData()
    }
    
    @IBAction func songTimerMoved(_ sender: Any) {
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
            audioPlayer.currentTime = TimeInterval(songTimerSlider.value)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        if let audioPlayer = audioPlayer {
            if paused == false {
                audioPlayer.pause()
                paused = true
            } else {
                audioPlayer.play()
                paused = false
            }
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
            audioPlayer.currentTime = TimeInterval(songTimerSlider.maximumValue - 0.05)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        isShuffled = true
        var randomGenerator = SystemRandomNumberGenerator()
        shuffledSongs = songs
        shuffledSongs = shuffledSongs.shuffled(using: &randomGenerator)
        print(shuffledSongs[counter].name)
        playShuffledSongs()
    }
    
    
}
