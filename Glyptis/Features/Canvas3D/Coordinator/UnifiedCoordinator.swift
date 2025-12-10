//
//  UnifiedCoordinator.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI
internal import RealityKit
import Combine
import ARKit

protocol CubeDelegate: AnyObject {
    func didAddCube(x: Float, y: Float, z: Float, colorR: Float, colorG: Float, colorB: Float, colorA: Float)
    func didRemoveCube(x: Float, y: Float, z: Float)
}

class UnifiedCoordinator: NSObject, UIGestureRecognizerDelegate {
    
    // MARK: - Referências principais
    weak var delegate: CubeDelegate? = nil
    weak var arView: ARView?
    var anchor: AnchorEntity?
    var modelEntity: Entity?

    // MARK: - Configurações da grade
    let gridSize = 20
    let cubeSize: Float = 0.05
    let gap: Float = 0.0
    let gridLineWidth: Float = 0.002

    var baseOffset: Float {
        (Float(gridSize) * (cubeSize + gap)) / 2.0 - cubeSize / 2.0
    }

    // MARK: - Estado dos cubos
    var heights: [String: Int] = [:]
    var columns: [String: [ModelEntity]] = [:]
    var activePreviews: [ModelEntity] = []
    
    // MARK: - Estado da câmera
    var currentRotationY: Float = 0
    var currentPitch: Float = .pi / 6 // 30 graus (Normal)
    var currentScale: Float = 1.0
    var lastTranslation = CGPoint.zero

    // MARK: - Modo de edição
    var removeMode: Bool = false
    var selectedColor: UIColor = .lightGray

    // MARK: - Modelo 3D externo
    var usdzScale: Float = 1.0
    var usdzOffset: SIMD3<Float> = .zero
    
    // MARK: - Escultura atual
    var currentSculpture: Sculpture?

    // MARK: - Ações de Câmera
    
    /// Alterna entre visão normal e visão aérea (topo)
    func toggleAerialView() {
        // Se estiver com angulo alto (perto de 90 graus), volta para normal (30)
        // Se estiver baixo, vai para o topo (~85 graus para não bugar o gimbal lock)
        if currentPitch > 1.0 {
            currentPitch = .pi / 6
        } else {
            currentPitch = .pi / 2 - 0.1
        }
        updateCameraPosition(animated: true)
    }
}
