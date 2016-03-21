//
//  PlayerViewController.swift
//  Pitch Perfect
//
//  Created by Jon on 3/20/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var pauseButtonOutlet: UIButton!
    
    @IBOutlet weak var resumeButtonOutlet: UIButton!
    
    @IBOutlet weak var slowButtonOutlet: UIButton!
    
    @IBOutlet weak var fastButtonOutlet: UIButton!
    
    @IBOutlet weak var lowPitchButtonOutlet: UIButton!
    
    @IBOutlet weak var highPitchButtonOutlet: UIButton!
    
    @IBOutlet weak var reverbButtonOutlet: UIButton!
    
    @IBOutlet weak var echoButtonOutlet: UIButton!
    
    // received audio
    
    var receivedAudio:RecordedAudio!
    
    // this is AVAudioPlayers way to alter sound
    
    // create an audio engine
    
    var audioEngine: AVAudioEngine!
    
    // sound file
    
    var audioFile: AVAudioFile!
    
    // audio player
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // initialize the audio engine
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile()
        audioPlayer = AVAudioPlayer()
        
        // setup sound file path
        
        do
        {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathURL)
        }
        catch
        {
            print("unable to load audio file")
        }
        
        resumeButtonOutlet.hidden = false;
        
    }
    @IBAction func pauseAudio(sender: AnyObject)
    {
        
    }
    
    @IBAction func resumeAudio(sender: AnyObject)
    {
        // audioPlayer.stop()
        // audioEngine.stop()
        // audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func slowOption(sender: AnyObject)
    {
        
    }
    
    @IBAction func fastOption(sender: AnyObject)
    {
        
    }
    
    @IBAction func lowPitchOption(sender: AnyObject)
    {
        
    }
    
    @IBAction func highPitchOption(sender: AnyObject)
    {
        
    }
    
    @IBAction func reverbOption(sender: AnyObject)
    {
        
    }
    
    @IBAction func echoOption(sender: AnyObject)
    {
        
    }


}
