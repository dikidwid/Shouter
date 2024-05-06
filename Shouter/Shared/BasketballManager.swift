//
//  BasketballManager.swift
//  Shouter
//
//  Created by Diki Dwi Diro on 01/05/24.
//

import SwiftUI

class BasketballManager: ObservableObject {
    static let shared = BasketballManager()
    
    @Published var totalShots: Int = 0
    @Published var totalScore: Int = 0
    @Published var isHoopEntityPlaced: Bool = false
    @Published var impulseMagnitude: Float = -1
    @Published var decible: Float = 0.0
}
