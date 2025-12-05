//
//  UnifiedCoordinator+Cubes..swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import Foundation
internal import RealityKit
internal import UIKit
import AVFoundation

extension UnifiedCoordinator {
    
    // MARK: - Cubos
    
    // Função auxiliar para disparar vibração
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    // Adiciona um cubo na posição calculada a partir da key "x_z"
    func addCube(atKey key: String, fromBase: Bool = false) {
        let parts = key.split(separator: "_")
        guard parts.count == 2,
              let x = Int(parts[0]), let z = Int(parts[1]) else { return }
        
        var targetLayer = 0
        
        while isSpaceOccupied(key: key, layer: targetLayer) {
            targetLayer += 1
        }
        
        if targetLayer >= gridSize { return }
        
        let posY = (cubeSize / 2) + (Float(targetLayer) * cubeSize)
        let posX = Float(x) * (cubeSize + gap) - baseOffset
        let posZ = Float(z) * (cubeSize + gap) - baseOffset
        
        addCube(at: SIMD3<Float>(posX, posY, posZ), key: key)
    }
    
    func addCube(_ cube: Cube) {
        let key = "\(Int(cube.locationX))_\(Int(cube.locationZ))"
        let position = SIMD3<Float>(cube.locationX, cube.locationY, cube.locationZ)
        
        _ = UIColor(
            red: CGFloat(cube.colorR),
            green: CGFloat(cube.colorG),
            blue: CGFloat(cube.colorB),
            alpha: CGFloat(cube.colorA ?? 1)
        )
        
        addCube(at: position, key: key)
    }
    
    // Adiciona um cubo diretamente na posição 3D com animação
    func addCube(at position: SIMD3<Float>, key: String) {
        guard let anchor = anchor else { return }
        
        triggerHaptic(style: .medium)
        SoundManager.shared.playSound(named: "addCube", volume: 4)
        
        let parts = key.split(separator: "_")
        let x = Int(parts[0])!
        let z = Int(parts[1])!
        let layer = heights[key] ?? 0
        
        let cube = ModelEntity(
            mesh: .generateBox(size: cubeSize),
            materials: [SimpleMaterial(color: selectedColor, isMetallic: false)]
        )
        
        /// 1. Define a posição final
        cube.position = position
        cube.name = "cell_\(x)_\(z)_\(layer)"
        cube.generateCollisionShapes(recursive: false)
        
        /// 2. CONFIGURAÇÃO INICIAL DA ANIMAÇÃO:
        /// Começa invisível
        cube.scale = SIMD3<Float>(0.01, 0.01, 0.01)
        
        /// 3. Adiciona à cena
        anchor.addChild(cube)
        columns[key, default: []].append(cube)
        
        heights[key] = (heights[key] ?? 0) + 1
        
        /// 4. RODA A ANIMAÇÃO:
        /// Cria um transform com a escala final (1.0 = 100% do tamanho)
        var targetTransform = cube.transform
        targetTransform.scale = SIMD3<Float>(1.0, 1.0, 1.0)
        
        /// Animação de 0.25s com curva 'easeOut' (rápido no começo, suave no final)
        /// Isso cria um efeito tátil de "construção"
        cube.move(to: targetTransform,
                  relativeTo: cube.parent,
                  duration: 0.10,
                  timingFunction: .easeOut)
        
        print("cube just added \(cube)")
    }
    
    // Verifica se já existe um cubo naquela coordenada específica
    func isSpaceOccupied(key: String, layer: Int) -> Bool {
        guard let list = columns[key] else { return false }
        
        /// Calcula a posição Y esperada para essa layer
        let targetY = (cubeSize / 2) + (Float(layer) * cubeSize)
        
        /// Verifica se algum cubo da lista está nessa posição
        return list.contains { abs($0.position.y - targetY) < 0.001 }
    }
    
    // Função auxiliar para criar o efeito de estilhaços
    func spawnDebris(at position: SIMD3<Float>, color: UIColor) {
        guard let anchor = anchor else { return }
        
        /// 8 pedaços menores
        let debrisCount = 4
        let debrisSize = cubeSize / 3.0
        
        for _ in 0..<debrisCount {
            let debris = ModelEntity(
                mesh: .generateBox(size: debrisSize),
                materials: [SimpleMaterial(color: color, isMetallic: false)]
            )
            
            /// Posição inicial levemente aleatória dentro da área do cubo original
            let offset = Float.random(in: -cubeSize/4...cubeSize/4)
            debris.position = position + SIMD3<Float>(offset, offset, offset)
            
            /// Rotação aleatória inicial
            debris.orientation = simd_quatf(angle: .pi, axis: [Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)])
            
            anchor.addChild(debris)
            
            /// ANIMAÇÃO DE EXPLOSÃO
            /// 1. Destino: Voar para longe
            let direction = SIMD3<Float>(
                Float.random(in: -0.2...0.2),
                Float.random(in: -0.1...0.2),
                Float.random(in: -0.2...0.2)
            )
            
            var transform = debris.transform
            transform.translation += direction
            transform.scale = SIMD3<Float>(0.01, 0.01, 0.01)
            transform.rotation = simd_quatf(angle: .pi * 3, axis: [Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)]) // Gira muito
            
            /// Roda  a animação
            debris.move(to: transform,
                        relativeTo: debris.parent,
                        duration: 0.4,
                        timingFunction: .easeOut)
            
            /// Limpa da memória após a animação
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                debris.removeFromParent()
            }
        }
    }
    
    // Remove um cubo com efeito de "Quebrar"
    func removeSpecificCube(entity: Entity, key: String) {
        guard var list = columns[key] else { return }
        
        guard let index = list.firstIndex(where: { $0 === entity }) else { return }
        let position = entity.position
        
        triggerHaptic(style: .medium)
        SoundManager.shared.playSound(named: "removeCube", volume: 4)
        
        var debrisColor: UIColor = .gray
        if let modelEntity = entity as? ModelEntity,
           let material = modelEntity.model?.materials.first as? SimpleMaterial {
            debrisColor = material.color.tint
        }
        
        /// 1. EFEITO VISUAL (EXPLOSÃO)
        spawnDebris(at: position, color: debrisColor)
        
        /// 2. REMOÇÃO LÓGICA
        list.remove(at: index)
        columns[key] = list
        
        if list.isEmpty {
            heights[key] = 0
        } else {
            let maxY = list.map { $0.position.y }.max() ?? 0
            let topLayerIndex = Int((maxY - (cubeSize / 2)) / cubeSize)
            heights[key] = topLayerIndex + 1
        }
        
        delegate?.didRemoveCube(x: position.x, y: position.y, z: position.z)
        
        /// 3. REMOÇÃO DO CUBO ORIGINAL
        entity.removeFromParent()
    }
    
    // Limpa todos os cubos com efeito de "Explosão"
    func clearAllCubes() {
        /// 1. Haptic
        triggerHaptic(style: .heavy)
        SoundManager.shared.playSound(named: "cleanCubes", volume: 3)
        
        /// 2. Coleta todos os cubos para animar
        var allCubes: [ModelEntity] = []
        for (_, list) in columns {
            allCubes.append(contentsOf: list)
        }
        
        /// 3. Limpa os dados lógicos imediatamente
        columns.removeAll()
        heights.removeAll()
        removeActivePreviews()
        
        /// 4. Animação de Explosão
        for cube in allCubes {
            var targetTransform = cube.transform
            
            /// A. Voar para uma direção aleatória (espalhar)
            let explosionForce: Float = 0.5 // Quão longe eles voam
            let randomOffset = SIMD3<Float>(
                Float.random(in: -explosionForce...explosionForce),
                Float.random(in: 0.1...explosionForce), // Tendência a voar um pouco pra cima
                Float.random(in: -explosionForce...explosionForce)
            )
            targetTransform.translation += randomOffset
            
            /// B. Girar (perda de estabilidade)
            targetTransform.rotation = simd_quatf(angle: .pi * 2, axis: [
                Float.random(in: -1...1),
                Float.random(in: -1...1),
                Float.random(in: -1...1)
            ])
            
            /// C. Diminuir até sumir
            targetTransform.scale = SIMD3<Float>(0.01, 0.01, 0.01)
            
            /// D. Duração variável para parecer uma explosão orgânica
            let randomDuration = Double.random(in: 0.3...0.6)
            
            cube.move(to: targetTransform,
                      relativeTo: cube.parent,
                      duration: randomDuration,
                      timingFunction: .easeOut)
            
            /// 5. Remove da memória ao fim da animação
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDuration) {
                cube.removeFromParent()
            }
        }
    }
    
    // MARK: Pré-visualização de adjacentes
    
    func showPreviewCubes(for x: Int, y: Int, z: Int, color: UIColor) {
        removeActivePreviews()
        guard let anchor = anchor else { return }
        
        let directions: [(dx: Int, dy: Int, dz: Int)] = [
            (0, 1, 0),  /// Cima
            (0, -1, 0), /// Baixo
            (-1, 0, 0), /// Esquerda
            (1, 0, 0),  /// Direita
            (0, 0, -1), /// Frente
            (0, 0, 1)   /// Trás
        ]
        
        for dir in directions {
            let nx = x + dir.dx
            let ny = y + dir.dy
            let nz = z + dir.dz
            
            guard nx >= 0, nx < gridSize, nz >= 0, nz < gridSize else { continue }
            guard ny >= 0, ny < gridSize else { continue }
            
            let keyNeighbor = "\(nx)_\(nz)"
            
            if isSpaceOccupied(key: keyNeighbor, layer: ny) { continue }
            
            let posY = (cubeSize / 2) + (Float(ny) * cubeSize)
            let pos = SIMD3<Float>(
                Float(nx) * (cubeSize + gap) - baseOffset,
                posY,
                Float(nz) * (cubeSize + gap) - baseOffset
            )
            
            let preview = createPreviewCube(at: pos, key: keyNeighbor, color: color, size: cubeSize)
            anchor.addChild(preview)
            activePreviews.append(preview)
        }
    }
    
    func removeActivePreviews() {
        activePreviews.forEach { $0.removeFromParent() }
        activePreviews.removeAll()
    }
    
    func createPreviewCube(at position: SIMD3<Float>, key: String, color: UIColor, size: Float) -> ModelEntity {
        let material = SimpleMaterial(color: color.withAlphaComponent(0.4), isMetallic: false)
        let cube = ModelEntity(mesh: .generateBox(size: size), materials: [material])
        
        cube.position = position
        cube.name = "preview_\(UUID().uuidString)"
        cube.components[PreviewCubeComponent.self] = PreviewCubeComponent(key: key)
        cube.generateCollisionShapes(recursive: false)
        
        return cube
    }
}
