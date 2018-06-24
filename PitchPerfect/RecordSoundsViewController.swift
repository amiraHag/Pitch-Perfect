//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Amira on 4/8/18.
//  Copyright © 2018 com.placeholder. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Disable Stop recording button when the app is initially loaded
        stopRecordingButton.isEnabled = false
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func recordAudio(_ sender: Any) {
        
        //Enable Stop recording button when Record button clicked
        stopRecordingButton.isEnabled = true
        
        //Disable Record Button when its clicked
        recordButton.isEnabled = false
        
        //Update the label to Recording in Progress
        recordingLabel.text = "Recording in Progress"
        
        //Setup record audio main function
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        //Identify the delgate class for tha audio
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
     
        //Enable Record button when  Stop recording button clicked
        recordButton.isEnabled = true
        
        //Disable Stop recording button when its clicked
        stopRecordingButton.isEnabled = false
        
        //Update the label to tab to record
        recordingLabel.text = "Tab to Record"
        
        //Stop the audio recorder
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // function that will tell the audio recorder what to do once it finished recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       
        
        //check if the audio recorder successfully record and save file
        //if success perform the segue and send the file path
        //if not success print message
        if(flag){
             print("Finished Recording")
             performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
             print("Recording not finished")
        }
    }
    
    
    //function that will prepared the viewcontroller before the segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "stopRecording"){
        let playSoundVC = segue.destination as! PlaySoundsViewController
        let recordedAudioURL = sender as! URL
        playSoundVC.recordAudioURL = recordedAudioURL
    }
    }
}

