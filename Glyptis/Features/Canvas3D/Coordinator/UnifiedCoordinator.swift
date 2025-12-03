//
//  UnifiedCoordinator.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//
// Coordinator responsável por gerenciar a cena AR, cubos e interações do usuário.

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
    weak var arView: ARView? /// ARView gerenciada
    var anchor: AnchorEntity?   /// Anchor principal da cena
    var modelEntity: Entity?  /// Modelo de referência carregado (usdz)

    // MARK: - Configurações da grade
    let gridSize = 10
    let cubeSize: Float = 0.1
    let gap: Float = 0.0
    let gridLineWidth: Float = 0.002

    /// Calcula o offset da grade para centralizar
    var baseOffset: Float {
        (Float(gridSize) * (cubeSize + gap)) / 2.0 - cubeSize / 2.0
    }

    // MARK: - Estado dos cubos
    var heights: [String: Int] = [:]
    var columns: [String: [ModelEntity]] = [:]
    var activePreviews: [ModelEntity] = []
    
    // MARK: - Estado da câmera
    var currentRotationY: Float = 0
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
}
