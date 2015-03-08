//
//  recordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Duck on 3/4/15.
//  Copyright (c) 2015 Kevin Duck. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //Create UI objects
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        //Record user's audio
        
        //Show stop button once recording starts
        stopButton.hidden = false
        
        //Show label indicating recording
        recordingLabel.hidden = false
        recordingLabel.text = "Recording in Progress ..."
        //Prevent user from interrupting recording with a new recording
        recordButton.enabled = false
        
        //Create path for recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Give recording file a name based on current time
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Start audio session in preparation for playing and recording
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //Force output to speaker`
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        
        //Set audioRecorder to an instance of AVAudioRecorder with the file at the filePath URL
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //Set us as the delegate
        audioRecorder.delegate = self
        //Turn on auto level metering, prepare for recording, and then start recording
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //If statement to check if audio successfully finished recording
        if (flag) {
            //Set recordedAudio as a RecordedAudio object and set up a file path
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            //Change view to the one with identifier "stopRecording"
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            //If audio recorder didn't finish successfully, reset everything
            println("Couldn't finish recording")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            //Change views to one of class playSoundsViewController and pass recorded audio to it
            let playSoundsVC:playSoundsViewController = segue.destinationViewController as playSoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    //TODO: Figure out how to pause and resume recording!
/*    @IBAction func pauseRecording(sender: UIButton) {
        //If recording, pause recoridng, or else resume it
        if (audioRecorder.recording) {
            audioRecorder.pause()
        } else {
            audioRecorder.record()
        }
        
        
    }
*/
    @IBAction func stopAudio (sender: UIButton) {
        recordButton.enabled = true
        recordingLabel.hidden = true
        stopButton.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)

        
    }
}

