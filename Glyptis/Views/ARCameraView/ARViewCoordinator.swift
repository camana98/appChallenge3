//
//  ARViewCoordinator.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//
import ARKit
import RealityKit
import Foundation

class ARViewCoordinator: NSObject {
    
    var arView: ARView?
    
    // MARK: SETUP
    
    func setupARView() -> ARView {
        
        let arView = ARView(frame: .zero)
        self.arView = arView
        
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal, .vertical]
        
        arView.session.run(config)
        
        self.arView = arView
        return arView
    }
    
    // MARK: FUNCS
    
}
