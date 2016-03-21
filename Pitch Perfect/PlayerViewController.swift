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

    // button outlets
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
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
    
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // initialize the audio engine
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile()
        audioPlayerNode = AVAudioPlayerNode()
        
        // setup sound file path
        
        do
        {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathURL)
        }
        catch
        {
            print("unable to load audio file")
        }
        
    }
    
    @IBAction func stopAudio(sender: AnyObject)
    {
        // pause audio and hide pause button
        
        audioPlayerNode.stop()
        
        resetEngine()
        
        stopButtonOutlet.hidden = true;
        
    }
    
    @IBAction func slowOption(sender: AnyObject)
    {
        playAudioWithNewSpeed(0.5,pitch:  2000)
    }
    
    @IBAction func fastOption(sender: AnyObject)
    {
        playAudioWithNewSpeed(2.0, pitch: -2000)
    }
    
    @IBAction func lowPitchOption(sender: AnyObject)
    {
        playAudioWithAlteredPitch(1000.0)
    }
    
    @IBAction func highPitchOption(sender: AnyObject)
    {
        playAudioWithAlteredPitch(-1000.0)
    }
    
    func playAudioWithAlteredPitch(pitch: Float)
    {
        resetEngine()
        
        // use pitch change audio effect
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect to engine
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        playAudio()
    }
    
    func playAudioWithNewSpeed(speed: Float, pitch: Float)
    {
        resetEngine()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // speed is changed
        
        let changeSpeedEffect = AVAudioUnitVarispeed()
        changeSpeedEffect.rate = speed
        audioEngine.attachNode(changeSpeedEffect)
        
        // alter pitch to bring it back to a normal pitch
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)

        // connect to engine
        
        audioEngine.connect(audioPlayerNode, to: changeSpeedEffect, format: nil)
        audioEngine.connect(changeSpeedEffect, to: audioEngine.outputNode, format: nil)
        
        playAudio()
    }
    
    @IBAction func reverbOption(sender: AnyObject)
    {
        resetEngine()
        
        // create reverb effect
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverb = AVAudioUnitReverb()
        reverb.wetDryMix = 80.0
        audioEngine.attachNode(reverb)
        
        // connect to engine

        audioEngine.connect(audioPlayerNode, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: nil)
        
        playAudio()
    }
    
    @IBAction func echoOption(sender: AnyObject)
    {
        resetEngine()
        
        // create echo effect
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let echo = AVAudioUnitDelay()
        echo.delayTime = 1.0
        audioEngine.attachNode(echo)
        
        // connect to engine and play audio
        
        audioEngine.connect(audioPlayerNode, to: echo, format: nil)
        audioEngine.connect(echo, to: audioEngine.outputNode, format: nil)
        
        playAudio()
        
    }
    
    func resetEngine()
    {
        // stop audio engine
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio()
    {
        // load audio file and play based on engine specs
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
        stopButtonOutlet.hidden = false;

    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool)
    {
        audioEngine.stop()
        audioEngine.reset()
        
        stopButtonOutlet.hidden = true;

    }
}
