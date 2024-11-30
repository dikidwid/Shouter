//
//  AudioPlayer.swift
//
//
//  Created by Diki Dwi Diro on 22/02/24.
//

import Foundation
import AVFoundation

class AudioPlayer {
    static let shared = AudioPlayer()
    
    var BGMPlayer: AVAudioPlayer?
    var defaultVolume: Float = 2
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "BGM", withExtension: "mp3") else { return }
        
        do {
            BGMPlayer = try AVAudioPlayer(contentsOf: url)
            BGMPlayer?.numberOfLoops = -1
            BGMPlayer?.volume = defaultVolume
            BGMPlayer?.play()
        } catch {
            print("Couldn't load file with error: \(error)")
        }
    }
    
    func unMuteMusic() {
        BGMPlayer?.volume = defaultVolume
    }
    
    func mutemusic() {
        BGMPlayer?.volume = 0
    }
    
    func stopMusic() {
        BGMPlayer?.stop()
    }
}
