//
//  ARViewCoordinator.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//
import ARKit
internal import RealityKit
import Foundation
import SwiftUI

class ARViewCoordinator: NSObject, ARCoachingOverlayViewDelegate {
    
    var arView: ARView?
    
    // MARK: SETUP
    
    func setupARView() -> ARView {
        
        let arView = ARView(frame: .zero)
        self.arView = arView
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal, .vertical]
        
        setupCoachingOverlay(arView: arView)
        
        arView.session.run(config)
        
        self.arView = arView
        return arView
    }
    
    // MARK: FUNCS
    private func setupCoachingOverlay(arView: ARView) {
        let coachingOverlay = ARCoachingOverlayView()
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        arView.addSubview(coachingOverlay)
        
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor)
        ])
        
        coachingOverlay.goal = .anyPlane
        
        coachingOverlay.session = arView.session
        coachingOverlay.delegate = self
        
        coachingOverlay.activatesAutomatically = true
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // aqui aparecer UI
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        // aqui esconder UI
    }
}
