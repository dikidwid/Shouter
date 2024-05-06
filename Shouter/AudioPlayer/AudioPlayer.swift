//
//  AudioPlayer.swift
//
//
//  Created by Diki Dwi Diro on 22/02/24.
//

import Foundation
import AVFoundation

class AudioPlayer {
    var BGMPlayer: AVAudioPlayer?
    private var volume: Float = 0.75
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "BGM", withExtension: "mp3") else { return }
        
        do {
            BGMPlayer = try AVAudioPlayer(contentsOf: url)
            BGMPlayer?.numberOfLoops = -1
            BGMPlayer?.volume = volume
            BGMPlayer?.setVolume(5, fadeDuration: 1)
            BGMPlayer?.play()
        } catch {
            print("Couldn't load file with error: \(error)")
        }
    }
    
    func stopMusic() {
        BGMPlayer?.stop()
    }
}
