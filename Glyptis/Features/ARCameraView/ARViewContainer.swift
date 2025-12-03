//
//  ARViewContainer.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//
/*
import Foundation
import ARKit
internal import RealityKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var coordinator: ARViewCoordinator
    
    func makeUIView(context: Context) -> some UIView {
        let view = coordinator.setupARView()
        view.accessibilityIdentifier = "arViewContainer" // para UITests
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // não faz nada
    }
    
}
*/

import Foundation
import ARKit
import SwiftUI
internal import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
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

