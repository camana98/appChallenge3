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

    func updateCameraPosition(animated: Bool) {
        guard let anchor = anchor else { return }

        let radius: Float = 2.5 * currentScale
        
        // Usa currentPitch (controlado pelo botão Visão Aérea)
        let horizontalRadius = radius * cos(currentPitch)
        let camY = radius * sin(currentPitch)
        
        let camX = horizontalRadius * sin(currentRotationY)
        let camZ = horizontalRadius * cos(currentRotationY)

        let targetPosition = SIMD3<Float>(camX, camY, camZ)

        // 1. Reutiliza câmera para evitar flicker
        let cameraEntity: PerspectiveCamera
        if let existingCamera = anchor.findEntity(named: "camera") as? PerspectiveCamera {
            cameraEntity = existingCamera
        } else {
            cameraEntity = PerspectiveCamera()
            cameraEntity.name = "camera"
            cameraEntity.camera.near = 0.01
            cameraEntity.camera.far = 100.0
            anchor.addChild(cameraEntity)
        }

        // 2. Aplica posição
        if animated {
            let currentTransform = cameraEntity.transform
            
            cameraEntity.look(at: .zero, from: targetPosition, relativeTo: nil)
            let targetTransform = cameraEntity.transform
            
            cameraEntity.transform = currentTransform
            cameraEntity.move(to: targetTransform, relativeTo: nil, duration: 0.3, timingFunction: .easeInOut)
        } else {
            cameraEntity.look(at: .zero, from: targetPosition, relativeTo: nil)
        }
    }

    func updateRotation(_ value: Float) {
        currentRotationY = value
        updateCameraPosition(animated: false)
    }

    func updateCamera(animated: Bool = false) {
        updateCameraPosition(animated: animated)
    }
}
