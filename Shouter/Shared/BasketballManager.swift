//
//  BasketballManager.swift
//  Shouter
//
//  Created by Diki Dwi Diro on 01/05/24.
//

import SwiftUI

class BasketballManager: ObservableObject {
    static let shared = BasketballManager()
    
    @Published var isPaused: Bool = false
    @Published var isTimerRunning: Bool = true
    @Published var progressBarValue: Float = 0.0
    
    @Published var totalScore: Int = 0
    @Published var isShowGameOverlay: Bool = false
    
    @Published var isHoopEntityPlaced: Bool = false
    @Published var isHoopPlaceAble: Bool = false
    
    @Published var impulseMagnitude: Float = -1
    @Published var decible: Float = 0.0
    
    func startGame() {
        isTimerRunning = true
        isHoopEntityPlaced = true
    }
    
    func restartGame() {
        isTimerRunning = false
        isHoopEntityPlaced = false
        isShowGameOverlay = false
        totalScore = 0
        progressBarValue = 0
        ARManager.shared.actionStream.send(.repositionHoop)
    }
    
    func stopGame() {
        isTimerRunning = false
        isHoopEntityPlaced = false
    }
}
