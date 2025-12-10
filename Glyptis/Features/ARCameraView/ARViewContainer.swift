//
//  ARViewContainer.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import Foundation
import ARKit
internal import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARViewCoordinator.shared.arView
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}
