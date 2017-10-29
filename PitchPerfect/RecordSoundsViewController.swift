//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Adrien Nhem on 28/10/2017.
//  Copyright © 2017 Adrien Nhem. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    let alertController = UIAlertController(title: "Alert", message: "Recording was not successful", preferredStyle: .alert)

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    // Records audio when button is pressed
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: false)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print (filePath as Any)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    // Verifies that recording did finish and saved
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Makes sure that recorded audio is passed to PlaySoundsController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // Enable and disable UI button when recording
    func configureUI(isRecording: Bool) {
        if isRecording {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        } else {
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "Recording in Progress"
        }
    }
}

