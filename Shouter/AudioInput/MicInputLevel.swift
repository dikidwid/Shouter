//
//  MicInputLevel.swift
//  Shouter
//
//  Created by Raphael on 01/05/24.
//

import Foundation
import AVFoundation
import AVFAudio

internal func setUpAudioCapture() {
    
    //    let recordingSession = AVAudioSession.sharedInstance()
    let recordingSession = AVAudioSession.sharedInstance()
    
    
    do {
        try recordingSession.setCategory(.playAndRecord)
        try recordingSession.setActive(true)
        
        AVAudioApplication.requestRecordPermission(){ granted in
            if granted {
                captureAudio()
            } else {
                print("ERROR: Failed to set up recording session.")
            }
        }
        
        //        recordingSession.requestRecordPermission({ result in
        //                guard result else { return }
        //            })
        
    } catch {
        print("ERROR: Failed to set up recording session.")
    }
}

private func captureAudio() {
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let audioFilename = documentPath.appendingPathComponent("recording.m4a")
    let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
        
        let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
        audioRecorder.record()
        audioRecorder.isMeteringEnabled = true
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            audioRecorder.updateMeters()
            let db = audioRecorder.averagePower(forChannel: 0)
            
            BasketballManager.shared.decible = db
            
            switch db {
            case -22...(-17):
                BasketballManager.shared.impulseMagnitude = -5
            case -16...(-11):
                BasketballManager.shared.impulseMagnitude = -7
            case -10...(-6):
                BasketballManager.shared.impulseMagnitude = -10
            case -5...4:
                BasketballManager.shared.impulseMagnitude = -14
            case -3...0:
                BasketballManager.shared.impulseMagnitude = -30
            default:
                BasketballManager.shared.impulseMagnitude = -1
            }
        }
    } catch {
        print("ERROR: Failed to start recording process.")
    }
}
