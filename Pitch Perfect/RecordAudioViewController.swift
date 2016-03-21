//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Jon on 2/29/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    
    @IBOutlet weak var helpLabel: UILabel!
    
    @IBOutlet weak var recordButtonOutlet: UIButton!
    
    @IBOutlet weak var stopButtonOutlet: UIButton!
    
    var startedRecording: Bool!

    var audioRecorder: AVAudioRecorder!
    
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        startedRecording = false;
        
        
        // setup sound file path
        
        // TODO: if I have time, write file name as the current date and time. then save all recordings and load them in the next view within a tableview
        
        
    }
    
    // method for when view appears after returning from PlayerView (or any other view)
    
    override func viewWillAppear(animated: Bool)
    {
        // TODO: add logic to reinitialize audio player if necessary
    }

    @IBAction func recordStart(sender: AnyObject)
    {
        if (startedRecording == false)
        {
            // start recording
            
            //Inside func recordAudio(sender: UIButton)
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            print(filePath)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
            // unhide stop button and disable record button
            
            recordButtonOutlet.enabled = false
            
            pauseButtonOutlet.hidden = false
            
            helpLabel.hidden = true

        }
        else
        {
            print("resuming recording")
            
            // resume recording
            
            audioRecorder.record()
            
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
        
        audioRecorder.pause()
        
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
        // stop the recording
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        print("stop button pressed")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        // when recording completes, segue to play view controller
        
        if(flag)
        {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("toPlayer", sender: self)
            
            print("changing controller")

        }
        else
        {
            print("recording failed")
            recordButtonOutlet.enabled = true;
            pauseButtonOutlet.hidden = true;
            stopButtonOutlet.hidden = true;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "toPlayer")
        {
            // sending over the recorded audio data
            let playerViewController = (segue.destinationViewController as! PlayerViewController)
            playerViewController.receivedAudio = recordedAudio
        }
        
    }
}

