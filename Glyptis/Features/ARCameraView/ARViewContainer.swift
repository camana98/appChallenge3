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
    
    @Binding var coordinator: ARViewCoordinator
    
    func makeUIView(context: Context) -> some UIView {
        // chama so quando é instanciada pela primeira vez
        return coordinator.setupARView()
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // não faz nada
    }
    
}
