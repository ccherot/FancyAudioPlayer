//
//  ViewController.swift
//  Fancy Audio Player
//
//  Created by Colin Cherot on 1/23/17.
//  Copyright © 2017 Colin Cherot. All rights reserved.
//

//TODO:  Add a list view nav thingy that loads a list of songs 
//or ideally a tree nav with the folder names and song lists
// -clreate classes for Artist, Album, AudioItem

// -pick out the mp3 tags and store that info?  Or can you leave it in the 
//tags?

import UIKit

import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    //the AVAudioPlayer
    var player = AVAudioPlayer()

    //this and the initialization and retrieval of songs from the file system or 
    //device should be moved to a UINavigationController delegate which populates
    //a table frmo which to select songs.
    var arrSongs:[AudioItem] = []
    
    //where in the playlist we are
    var currentPlaylistIndex = 0
    
    //string containing path to audio file
    var audioPath: String?
    
    //updates the progress text
    var updater: CADisplayLink? = nil
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func play(_ sender: Any) {
        
        //is the player paused 
        print("play: player is \(player)")
        
        //check for some kind of player resource!
        if (player.url == nil)
        {
            return
        }

        player.play()
        
        updater?.isPaused = false
        
    }

    @IBAction func pause(_ sender: Any) {
        
        //print("pause: player.url is \(player.url)")
        
        if (!player.isPlaying || player.url == nil)
        {
            return
        }

        
        
        player.pause()
        
        updater?.isPaused = true
    }
    
    @IBAction func stop(_ sender: Any) {
        
        print("stop")
        
        if (!player.isPlaying || player.url == nil)
        {
            return
        }
        
        player.stop()
        
        updater?.isPaused = true
        
    }
    
    @IBAction func skipForward(_ sender: Any) {
        
        
        print("skipForward")
        
        currentPlaylistIndex += 1
        
        if currentPlaylistIndex == arrSongs.count - 1
        {
            currentPlaylistIndex = 0
        }
        
        updateAudioPath()
        
        player.play()
    }
    
    @IBAction func goBack(_ sender: Any) {
        
        print("goBack")
        
        currentPlaylistIndex -= 1
        
        if currentPlaylistIndex < 0
        {
            currentPlaylistIndex = arrSongs.count - 1
        }
        
        updateAudioPath()
        
        player.play()
    }
    
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func volumeSliderMoved(_ sender: Any) {
        
        print("volumeSliderMoved")
        
        player.volume = volumeSlider.value
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBAction func progressSliderMoved(_ sender: Any) {
        
        //translate progressSlider.value to a time in the audio file
        //let sliderVal = player.currentTime * 100.0 / player.duration
        //if ((sender as? UISlider)?.state == )
        print("progressSLider moved and value is \(progressSlider.value)")
        
        
    }
    
    
    @IBAction func onProgSliderChanged(_ sender: Any) {

        print("onProgSliderChanged called")

        //let newTime = Double(progressSlider.value) * player.duration / 100
        print("value is \(progressSlider.value)")
        let newTime = TimeInterval(round(progressSlider.value))
        print("newTime:TimeInterval is \(newTime)")
        
        if player.isPlaying
        {
            player.pause()
        }
        player.currentTime = newTime
        
        player.play()
        //player.play(atTime: newTime)
        
    }
 
    override func viewDidLoad() {
        
        print("viewDidLoad")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //for now just create a bunch of AudioItems to play
        createAudioItems()
        
        //TODO: crawl the directories and create arrays of AudioItems
        //create AudioItems from the local Mac dir
        
        //TODO: retrieve music from the user's device
        //not that this might not be a synchronous operation
        
        //TODO: store this and the progress point locally?
        currentPlaylistIndex = 0
        
        
        
        updateAudioPath()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    let tuskenRaidersTracks = ["312_Sea_Dweller.mp3", "311 The Motorbike Track Remix 2.mp3", "310 The Motorbike Track Remix 1.mp3", "245 Phust.mp3", "204 Tanja.mp3", "203 Zgivoll.mp3", "202 B.F.C. - The Climax (Tusken Raiders Remix).mp3", "186 Groipnol.mp3", "185 Foifol.mp3", "184 Pollygol.mp3", "183 Blolp.mp3", "182 Lobot.mp3"]
    
    let afxTracks = ["186 3 Slothscrape.mp3", "185 13 Phukup2.mp3", "184 6 Backdrop Trigger.mp3", "183 6 Gear Smudge.mp3", "182 Medievil Rave Mk2 [pre plague mix].mp3", "181 1 Lmt B.mp3", "180 1 Lmt.mp3", "179 36 Shroommdot [miCro3] [8th dimension transmission].mp3", "178 25 grogphlange 1[braiNfLOSS2].mp3", "177 24 Triple D.mp3", "176 35 SAW II Un Road Shimmer F.mp3", "175 35 SAW II Un Road Shimmer.mp3", "174 18 SsbA.mp3", "173 22 Gak Bass.mp3", "172 30 Ms Short.mp3", "171 24 Casiotribaltronics2 Mfm.mp3"]
    
    func createAudioItems()
    {
        print("createAudioItems")
        
        for track in tuskenRaidersTracks{
        
            arrSongs.append(AudioItem(fileName: track, albumArt: "tuskenraiders.jpg"))
        
        }
        
        for track in afxTracks
        {
            arrSongs.append(AudioItem(fileName: track, albumArt: "AFX.jpg"))
        }
    }
    
    func updateAudioPath()
    {
        
        print("updateAudioPath: current AudioItem is \(arrSongs[currentPlaylistIndex]) and resourceName is \(arrSongs[currentPlaylistIndex].resourceName)" )
        print("updateAudioPath: fileType is \(arrSongs[currentPlaylistIndex].fileType)")
        
        let resource: String? = arrSongs[currentPlaylistIndex].resourceName
        let type: String? = "mp3" //arrSongs[currentPlaylistIndex].fileType
        
        //audioPath = Bundle.main.path(forResource: "312_Sea_Dweller", ofType: "mp3")
        
        audioPath = Bundle.main.path(forResource: resource, ofType: type)
        
        print("updateAudioPath: audioPath is \(audioPath)")
        
        self.title = arrSongs[currentPlaylistIndex].resourceName
        
        createPlayer()
    }
    
    func createPlayer()
    {
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
            player.delegate = self
            
            albumArtImageView.image = UIImage(named: arrSongs[currentPlaylistIndex].albumArt)
        }
        catch{
            print("Erorr trying to play content")
        }
        
        //TODO: only create the progress updater onnce
        createProgressUpdater()
 
    }
    
    func createProgressUpdater()
    {
        print("createProgbressUpdater")
        
        updater = CADisplayLink(target: self, selector: #selector(ViewController.updateProgress))
        //updater?.preferredFramesPerSecond = 2
        updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        //make the progress slider use a continuous number
        //progressSlider.isContinuous = false
        progressSlider.maximumValue = Float(player.duration)
        progressSlider.value = 0.0
    }
    
    @objc func updateProgress()
    {
        //print("updateProgress: currentTime is \(player.currentTime)")
        //update the prgress slider with the percentage of elapsed time
/*
        let sliderVal = player.currentTime * 100.0 / player.duration//Float(
        
        //print("updateProgress: sliderVal is \(sliderVal)")
        
        progressSlider.value = Float(sliderVal/100)
 */
        
        progressSlider.value = Float(player.currentTime)
        
        //update progress label
        let h = Int(player.currentTime / 3600)
        let min = Int(player.currentTime / 60)
        let sec = Int(player.currentTime.truncatingRemainder(dividingBy: 60))
        //let s = "00:\(min):\(sec)"
        let s = String(format: "%02d:%02d:%02d", h, min, sec)
        //print("updateProgress: s is \(s)")
        timeLabel.text = s
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        print ("audioPlayerDidFinishPLaying called")
        
        skipForward(self)
    }


}

