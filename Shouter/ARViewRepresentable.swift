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
    
    // MARK: - Properties
    
    @Binding var isOnVerticalPlane: Bool
    @Binding var isHoopEntityPlaced: Bool
    @Binding var shootBall: Bool
        
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)
        arView.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        if isHoopEntityPlaced {
            place(name: "hoop", in: .plane(.vertical, classification: .any, minimumBounds: SIMD2()), on: arView)
        }
        
        if shootBall {
            shootBall(in: arView)
            
            DispatchQueue.main.async {
                shootBall = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewRepresentable: self)
    }
    
    final class Coordinator: NSObject, CustomARViewDelegate {
        let arViewRepresentable: ARViewRepresentable
        
        init(arViewRepresentable: ARViewRepresentable) {
            self.arViewRepresentable = arViewRepresentable
        }
        
        func didFind(verticalPlane: Bool) {
            arViewRepresentable.isOnVerticalPlane = verticalPlane
        }
    }
}


// MARK: - Private
extension ARViewRepresentable {
    func place(name: String, in alignment: AnchoringComponent.Target, on arView: ARView) {
        if arView.scene.findEntity(named: name) == nil {
            guard let url = createRealityURL(filename: "hoop", fileExtension: "reality", sceneName: name + "Scene") else {
                print ("gada file realitynya bro")
                return
            }
            
            let entity = try! Entity.load(contentsOf: url)
            
            guard let modelEntity = entity.findEntity(named: name) else {
                print("Entity named: \(name) not found")
                return
            }
            
            let anchorEntity = AnchorEntity(alignment)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
        }
    }
    
    func shootBall(in arView: ARView) {
        guard let modelEntity = try? ModelEntity.loadModel(named: "ball") else {
            return print("Failed to load 3D model")
        }
        
        let anchorEntity = AnchorEntity(.camera)
        
        // Add physics properties to the model entity
        modelEntity.physicsBody = .init()
        modelEntity.physicsMotion = .init()
        modelEntity.generateCollisionShapes(recursive: true)
        
        modelEntity.transform.translation = [0, 0, -0.5]
        
        anchorEntity.addChild(modelEntity)
        
        // Add the anchor entity to the ARView's scene
        arView.scene.addAnchor(anchorEntity)
        
        // Add the velocity to the object after it loaded
        let impulseMagnitude: Float = -10
        let impulseVector = SIMD3<Float>(0, 0, impulseMagnitude)
        modelEntity.applyLinearImpulse(impulseVector, relativeTo: modelEntity.parent)
        
        DispatchQueue.main.async {
            shootBall = false
        }
    }
    
    private func createRealityURL(filename: String,
                                  fileExtension: String,
                                  sceneName:String) -> URL? {
        // Create a URL that points to the specified Reality file.
        guard let realityFileURL = Bundle.main.url(forResource: filename,
                                                   withExtension: fileExtension) else {
            print("Error finding Reality file \(filename).\(fileExtension)")
            return nil
        }
        
        
        // Append the scene name to the URL to point to
        // a single scene within the file.
        let realityFileSceneURL = realityFileURL.appendingPathComponent(sceneName,
                                                                        isDirectory: false)
        return realityFileSceneURL
    }
}

