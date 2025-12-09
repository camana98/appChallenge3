//
//  UnifiedCoordinator+Gestures.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

internal import UIKit
internal import RealityKit

extension UnifiedCoordinator {

    // MARK: - Gestures

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        let translation = gesture.translation(in: arView)
        if gesture.state == .began {
            lastTranslation = translation
        }

        let deltaX = Float(translation.x - lastTranslation.x)
        let deltaY = Float(translation.y - lastTranslation.y)

        currentRotationY -= deltaX * 0.01
        updateCameraPosition(animated: false)

        anchor?.position.y -= deltaY * 0.005
        lastTranslation = translation

        if gesture.state == .ended {
            lastTranslation = .zero
        }
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.state == .changed else { return }
        let pinchDelta = Float(gesture.scale - 1.0) * 0.3

        currentScale -= pinchDelta
        currentScale = max(0.4, min(currentScale, 2))

        updateCameraPosition(animated: true)
        gesture.scale = 1.0
    }

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        
        let location = gesture.location(in: arView)
        guard let entity = arView.entity(at: location) else {
            removeActivePreviews()
            return
        }
        
        if entity.name == "reference_model" {
            removeActivePreviews()
            return
        }
        
        if entity.name.starts(with: "preview_") {
            if let preview = entity.components[PreviewCubeComponent.self] {
                addCube(at: entity.position, key: preview.key)
                
                // Extrair componentes de cor
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                selectedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                delegate?.didAddCube(
                    x: entity.position.x,
                    y: entity.position.y,
                    z: entity.position.z,
                    colorR: Float(red),
                    colorG: Float(green),
                    colorB: Float(blue),
                    colorA: Float(alpha)
                )
                
                removeActivePreviews()
            }
            return
        }
        
        removeActivePreviews()
        
        if entity.name.starts(with: "base_") {
            if !removeMode, let parsed = parseBaseName(entity.name) {
                let key = "\(parsed.x)_\(parsed.z)"

                /*
                addCube(atKey: "\(parsed.x)_\(parsed.z)", fromBase: true)
                // Calcular posição (mesma lógica do addCube) TESTAR ASSIM, SE NÃO DER USE OS COMENTADOS
                let posX = Float(parsed.x)
                let posZ = Float(parsed.z)
//                let posX = Float(parsed.x) * (cubeSize + gap) - baseOffset
//                let posZ = Float(parsed.z) * (cubeSize + gap) - baseOffset
                
                
                // Extrair componentes de cor
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                selectedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                
                delegate?.didAddCube(
                    x: posX,
                    y: 0,
                    z: posZ,
                    colorR: Float(red),
                    colorG: Float(green),
                    colorB: Float(blue),
                    colorA: Float(alpha)
                )
                */


                
                // Calcular posição ANTES de adicionar (para pegar a altura correta)
                var targetLayer = 0
                while isSpaceOccupied(key: key, layer: targetLayer) {
                    targetLayer += 1
                }
                
                if targetLayer < gridSize {
                    let posY = (cubeSize / 2) + (Float(targetLayer) * cubeSize)
                    let posX = Float(parsed.x) * (cubeSize + gap) - baseOffset
                    let posZ = Float(parsed.z) * (cubeSize + gap) - baseOffset
                    
                    // Adiciona o cubo visual
                    addCube(atKey: key, fromBase: true)
                    
                    // Extrair componentes de cor
                    var red: CGFloat = 0
                    var green: CGFloat = 0
                    var blue: CGFloat = 0
                    var alpha: CGFloat = 0
                    selectedColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                    
                    delegate?.didAddCube(
                        x: posX,
                        y: posY,
                        z: posZ,
                        colorR: Float(red),
                        colorG: Float(green),
                        colorB: Float(blue),
                        colorA: Float(alpha)
                    )
                }
            }
            return
        }
        
        if let parsed = parseCellName(entity.name) {
            // Se estiver no modo remover
            if removeMode {
                // MUDANÇA: Passamos a entidade exata e a chave da coluna
                removeSpecificCube(entity: entity, key: "\(parsed.x)_\(parsed.z)")
            } else {
                // Lógica de adicionar (preview) continua igual...
                if let currentCube = arView.entity(at: gesture.location(in: arView)) {
                    showPreviewCubes(
                        for: parsed.x,
                        y: Int(currentCube.position.y / cubeSize),
                        z: parsed.z,
                        color: selectedColor
                    )
                }
            }
        }
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
