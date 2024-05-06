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
    func makeUIView(context: Context) -> ARView {
        return CustomARView(frame: .zero)
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
         
    }
}

