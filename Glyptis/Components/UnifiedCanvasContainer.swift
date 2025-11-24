//
//  CanvasGrid.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 24/11/25.
//

import Foundation
import SwiftUI
import RealityKit
import Combine
import ARKit

struct UnifiedCanvasContainer: UIViewRepresentable {
    @Binding var removeMode: Bool
    @Binding var selectedColor: Color
    @Binding var rotationY: Float
    
    var usdzFileName: String
    var modelScale: Float = 0.08
    var modelOffset: SIMD3<Float> = SIMD3<Float>(0, -2, 0)
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        arView.environment.background = .color(.clear)
        
        let anchor = AnchorEntity(world: .zero)
        arView.scene.anchors.append(anchor)
        context.coordinator.arView = arView
        context.coordinator.usdzScale = modelScale
        context.coordinator.usdzOffset = modelOffset
        context.coordinator.setupScene(anchor: anchor, usdzFileName: usdzFileName)
        

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(UnifiedCoordinator.handlePan(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(UnifiedCoordinator.handlePinch(_:)))
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(UnifiedCoordinator.handleTap(_:)))
        
        panGesture.delegate = context.coordinator
        pinchGesture.delegate = context.coordinator
        
        arView.addGestureRecognizer(panGesture)
        arView.addGestureRecognizer(pinchGesture)
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.removeMode = removeMode
        context.coordinator.selectedColor = UIColor(selectedColor)
    }
    
    func makeCoordinator() -> UnifiedCoordinator {
        UnifiedCoordinator()
    }
}
