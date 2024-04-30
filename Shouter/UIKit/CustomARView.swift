//
//  CustomARView.swift
//  BasketballAR
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import ARKit
import FocusEntity
import RealityKit

protocol CustomARViewDelegate {
    func didFind(verticalPlane: Bool)
}

class CustomARView: ARView {

    // MARK: - Properties

    var focusEntity: FocusEntity?
    var delegate: CustomARViewDelegate?

    // MARK: - Lifecycle

    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupFocusEntity()
        setupARView()
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
        focusEntity = FocusEntity(on: self, style: .classic(color: UIColor.yellow))
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
}

extension CustomARView: FocusEntityDelegate {
    func focusEntity(_ focusEntity: FocusEntity, trackingUpdated trackingState: FocusEntity.State, oldState: FocusEntity.State?) {
                
        delegate?.didFind(verticalPlane: focusEntity.onPlane)
    }
}
