//
//  ARViewContainer.swift
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
    @Binding var arView: ARView   // <- acesso direto ao ARView para snapshot
    
    func makeUIView(context: Context) -> ARView {
        // Só cria o ARView uma vez usando o coordinator
        let view = coordinator.setupARView()
        
        // Atualiza o binding do ARView para sua View SwiftUI
        self.arView = view
        
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // normalmente não precisa atualizar nada aqui
    }
}
