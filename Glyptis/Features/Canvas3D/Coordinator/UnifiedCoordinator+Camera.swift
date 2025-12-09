//
//  UnifiedCoordinator+Camera.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import Foundation
internal import RealityKit


extension UnifiedCoordinator {

    // MARK: - Camera

    /// Atualiza a posição da câmera na cena 3D
    func updateCameraPosition(animated: Bool) {
        guard let anchor = anchor else { return }

        let radius: Float = 2.5 * currentScale
        let fixedPitch: Float = .pi / 6

        let camX = radius * sin(currentRotationY)
        let camY = radius * sin(fixedPitch)
        let camZ = radius * cos(currentRotationY)

        let targetPosition = SIMD3<Float>(camX, camY, camZ)

        /// Remove câmeras anteriores
        anchor.children.filter { $0.name == "camera" }.forEach { $0.removeFromParent() }
        
        /// Cria nova câmera
        let cameraEntity = PerspectiveCamera()
        cameraEntity.name = "camera"
        cameraEntity.look(at: .zero, from: targetPosition, relativeTo: nil)

        if animated {
            let move = Transform(
                scale: .one,
                rotation: simd_quatf(),
                translation: targetPosition
            )
            cameraEntity.move(to: move, relativeTo: nil, duration: 0.15, timingFunction: .easeInOut)
        } else {
            cameraEntity.position = targetPosition
        }

        anchor.addChild(cameraEntity)
    }

    /// Atualiza a rotação horizontal da câmera
    func updateRotation(_ value: Float) {
        currentRotationY = value
        updateCameraPosition(animated: false)
    }

    /// Atualiza a càmera
    func updateCamera(animated: Bool = false) {
        updateCameraPosition(animated: animated)
    }
}
