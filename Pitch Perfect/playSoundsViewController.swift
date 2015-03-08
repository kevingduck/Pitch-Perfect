//
//  playSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Kevin Duck on 3/4/15.
//  Copyright (c) 2015 Kevin Duck. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Create AVAudioPlayer object with the audio file received from the previous view
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        //Enable adjustment of audio playback rate
        audioPlayer.enableRate = true
        
        //Create AVAudioEngine object and prepare to set it up with the audio file to be read
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
         
    }

    override func viewWillDisappear(animated: Bool) {
        audioFile = nil
    }
    
    //Play audio with adjusted pitch
    func playAudioWithVariablePitch(pitch: Float) {
        //Reset audioPlayer, engine to ensure it's not playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //Create player node object, attach to AVAudioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Create AVAudioUnitTimePitch and attach is to the engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //Connect the node to the engine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        //Connect the AVAudioUnitTimePitch object to the engine
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //Prepare player node file's playback schedule
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        //Start audio engine
        audioEngine.startAndReturnError(nil)
        
        //Play back whatever the audioPlayerNode has
        audioPlayerNode.play()
    
    }
    
    //Same as playAudioWithVariablePitch, but uses reverb effect instead of pitch adjustment
    //TODO: reuse code, combine this function and playAudioWithVariablePitch if possible
    func playAudioWithReverb() {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 90
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Audio plays back at 1.5x rate
    @IBAction func playFastSound(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.enableRate = true
        audioPlayer.rate = 1.5
        audioPlayer.play()
    }
    
    //Audio plays back at 0.5x rate
    @IBAction func playSlowSound(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.enableRate = true
        audioPlayer.rate = 0.5
        audioPlayer.play()
    }

    //Stop audio playback
    @IBAction func stopPlayback(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    //Audio plays back with decreased pitch
    @IBAction func playDarthAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-800)
    }
    
    //Audio plays back with increased pitch
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb()
    }

}
