//
//  CustomARView.swift
//  BasketballAR
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import ARKit
import FocusEntity
import RealityKit
import Combine

extension String {
    static let triggerModelEntityName = "triggerModelEntity"
    static let ballModelEntityName = "ballModelEntity"
}

protocol CustomARViewDelegate {
    func didFind(verticalPlane: Bool)
}

class CustomARView: ARView {
    
    var basketballManager: BasketballManager = BasketballManager.shared

    // MARK: - Properties

    var focusEntity: FocusEntity?
    var delegate: CustomARViewDelegate?
    
    var collisionSubscription: Cancellable?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupFocusEntity()
        setupARView()
        
        collisionSubscription = scene.publisher(for: CollisionEvents.Began.self,
                                                on: nil).sink(receiveValue: onCollisionBegan)
        subscribeToActionStream()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setupFocusEntity()
        setupARView()
    }
}

// MARK: - Private

private extension CustomARView {
    
    func setupFocusEntity() {
        focusEntity = FocusEntity(on: self, style: .classic(color: .clear))
        focusEntity?.setAutoUpdate(to: true)
        focusEntity?.delegate = self
    }
    
    func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .vertical
        config.environmentTexturing = .automatic
        config.frameSemantics = .personSegmentation
        config.frameSemantics = .personSegmentationWithDepth
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
    
    private func onCollisionBegan(_ event: CollisionEvents.Began) {
        let firstEntity = event.entityA
        let secondEntity = event.entityB
        
        if firstEntity.name == .triggerModelEntityName && secondEntity.name == .ballModelEntityName {
            print("First Goal!")
            basketballManager.totalScore += 1
        }
    }

    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                case .shootBall:
                    self?.shootBall()
                case .repositionHoop:
                    self?.scene.anchors.removeAll()
                case .placeHoop:
                    self?.placeModelEntity(name: "hoop", withAlignment: .plane(.vertical, classification: .any, minimumBounds: SIMD2()))
                }
            }
            .store(in: &cancellables)
    }
    
    func placeModelEntity(name: String, withAlignment alignment: AnchoringComponent.Target) {
        if scene.findEntity(named: name) == nil {
            guard let modelEntity = try? ModelEntity.loadModel(named: "hoop") else {
                return print("Failed to load 3D model")
            }
            
            debugOptions = .showPhysics
            
            // Set the modelEntity properties
            modelEntity.scale /= 2
            modelEntity.name = name
            
            // Add a custom hoop basketball collision to the hoop's model entity
            let hoopPlate = ShapeResource.generateBox(width: 0.8, height: 0.8, depth: 0.05)
                .offsetBy(rotation: simd_quatf(angle: .pi / 2, axis: [1, 0, 0]), translation: [0, 0.01, -0.09])
            let frontRing = ShapeResource.generateBox(width: 0.5, height: 0.04, depth: 0.05)
                .offsetBy(translation: [0, 0.625, 0.15])
            let rightRing = ShapeResource.generateBox(width: 0.04, height: 0.5, depth: 0.05)
                .offsetBy(translation: [0.265, 0.4 ,0.15])
            let leftRing = ShapeResource.generateBox(width: 0.04, height: 0.5, depth: 0.05)
                .offsetBy(translation: [-0.265, 0.4 ,0.15])
            let collissionShapes =  [hoopPlate, frontRing, rightRing, leftRing]
            modelEntity.components[CollisionComponent.self] = CollisionComponent(shapes: collissionShapes)
            modelEntity.components[PhysicsBodyComponent.self] = PhysicsBodyComponent(shapes: collissionShapes,
                                                                                     mass: 0,
                                                                                     material: nil,
                                                                                     mode: .static)
            
            // Invincible trigger box for scoring system
            let box = MeshResource.generateBox(width: 0.01, height: 0.01, depth: 0.01)
            let material = SimpleMaterial(color: UIColor.green, isMetallic: false)

            // First Trigger Entity
            let triggerModelEntity = ModelEntity(mesh: box, materials: [material])
            triggerModelEntity.collision = CollisionComponent(shapes: [.generateBox(width: 0.01, height: 0.01, depth: 0.01)], mode: .trigger, filter: .sensor)
            triggerModelEntity.name = .triggerModelEntityName
            triggerModelEntity.transform.translation = [0 , 0.375, 0.3]
            modelEntity.addChild(triggerModelEntity)

            let anchorEntity = AnchorEntity(alignment)
            anchorEntity.addChild(modelEntity)
            scene.addAnchor(anchorEntity)
        }
    }
    
    func shootBall() {
        guard let modelEntity = try? ModelEntity.loadModel(named: "ball") else {
            return print("Failed to load 3D model")
        }
    
        modelEntity.name = .ballModelEntityName
        
        // Add sphere physics collision to the model entity
        modelEntity.physicsBody = .init()
        modelEntity.physicsMotion = .init()
        let sphereShape = ShapeResource.generateSphere(radius: 0.110)
            .offsetBy(translation: [0, 0.1, 0])
        modelEntity.collision = CollisionComponent(shapes: [sphereShape], mode: .default)

        // Add the modelEntity the ARView's scene
        let anchorEntity = AnchorEntity(.camera)
        anchorEntity.addChild(modelEntity)
        scene.addAnchor(anchorEntity)
        
        // Add the velocity to the object after it loaded
        let impulseMagnitude: Float = basketballManager.impulseMagnitude
        let impulseVector = SIMD3<Float>(0, 0, impulseMagnitude)
        modelEntity.applyLinearImpulse(impulseVector, relativeTo: modelEntity.parent)
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

extension CustomARView: FocusEntityDelegate {
    func focusEntity(_ focusEntity: FocusEntity, trackingUpdated trackingState: FocusEntity.State, oldState: FocusEntity.State?) {
                
        delegate?.didFind(verticalPlane: focusEntity.onPlane)
    }
}
