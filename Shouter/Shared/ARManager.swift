//
//  ARManager.swift
//  Shouter
//
//  Created by Diki Dwi Diro on 01/05/24.
//

import Combine

class ARManager {
    static let shared = ARManager()
    private init() { }
    
    var actionStream = PassthroughSubject<ARAction, Never>()
}

enum ARAction {
    case placeHoop
    case shootBall
    case repositionHoop
}
