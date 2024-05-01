//
//  ARViewRepresentable.swift
//  BasketballAR
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import SwiftUI
import ARKit
import RealityKit
import Combine
import FocusEntity

struct ARViewRepresentable: UIViewRepresentable {
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)        
        
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        
    }
}


// MARK: - Private
extension ARViewRepresentable {
    
}

