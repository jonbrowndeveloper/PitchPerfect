//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Jon on 2/29/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    
    @IBOutlet weak var helpLabel: UILabel!
    
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    var startedRecording: Bool?

    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startedRecording = false;
        
        // initialize audio recorder settings including bit rate, sample rate, and number of channels
        
        let recorderSettings = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0]
        
        // setup sound file path
        
        let mainDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDir = mainDir[0]
        
        // TODO: if I have time, write file name as the current date and time. then save all recordings and load them in the next view within a tableview
        
        let soundFilePath = documentDir + "/soundFile.caf"
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        print("string \(soundFilePath)")
        
        // setup audio recorder in try catch block and capture any possible errors
        
        do
        {
            // initialize audio recorder
            
            audioRecorder = try AVAudioRecorder(URL: soundFileURL, settings: recorderSettings)
            audioRecorder?.delegate = self
            
            // does the job of creating the file at the fileURL and overwrites anything there
            
            audioRecorder?.prepareToRecord()
   
        }
        catch let error as NSError
        {
            audioRecorder = nil
            print(error.description)
        }
        
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordStart(sender: AnyObject)
    {
        if (startedRecording == false)
        {
            // start recording
            
            audioRecorder?.record()
            
            // unhide stop button and disable record button
            
            recordButtonOutlet.enabled = false
            
            pauseButtonOutlet.hidden = false
            
            helpLabel.hidden = true

        }
        else
        {
            print("resuming recording")
            
            // resume recording
            
            audioRecorder?.record()
            
            // unhide pause button, hide stop button, and disable record button
            
            pauseButtonOutlet.hidden = false;
            
            stopButtonOutlet.hidden = true;
            
            recordButtonOutlet.enabled = false;
            
            helpLabel.hidden = true
        }
        
        
    }
    
    @IBAction func pauseRecording(sender: AnyObject)
    {
        // pause recording
        
        audioRecorder?.pause()
        
        // hide pause button, show stop button and enable record button
        
        pauseButtonOutlet.hidden = true
        
        recordButtonOutlet.enabled = true
        
        stopButtonOutlet.hidden = false
        
        // set help label text and show
        
        helpLabel.hidden = false
        
        helpLabel.text = "tap to resume recording"
        
        // set bool for start of recording
        
        startedRecording = true;
    }
    
    @IBAction func stopRecording(sender: AnyObject)
    {
        audioRecorder?.stop()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        // when recording completes, segue to play view controller
        
        self .performSegueWithIdentifier("toPlayer", sender: self)
    }
}

