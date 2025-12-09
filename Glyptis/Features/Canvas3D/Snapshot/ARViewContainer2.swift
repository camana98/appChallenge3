//
//  ARViewContainer2.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 03/12/25.
//

import Foundation
import ARKit
import SwiftUI
internal import RealityKit

struct ARViewContainer2: UIViewRepresentable {
    
    @Binding var coordinator: ARViewCoordinator
    @Binding var arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        let view = coordinator.arView

        DispatchQueue.main.async {
            self.arView = view
        }
        
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}
