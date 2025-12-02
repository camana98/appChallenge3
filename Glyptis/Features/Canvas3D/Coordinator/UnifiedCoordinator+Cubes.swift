//
//  UnifiedCoordinator+Cubes..swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import Foundation
internal import RealityKit
internal import UIKit

extension UnifiedCoordinator {

    // MARK: - Cubos

    // Adiciona um cubo na posição calculada a partir da key "x_z"
    func addCube(atKey key: String, fromBase: Bool = false) {
        let parts = key.split(separator: "_")
        guard parts.count == 2,
              let x = Int(parts[0]), let z = Int(parts[1]) else { return }

        let currentHeight = heights[key] ?? 0
        let posY = (cubeSize / 2) + (Float(currentHeight) * cubeSize)

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

    // Adiciona um cubo diretamente na posição 3D
    func addCube(at position: SIMD3<Float>, key: String) {
        guard let anchor = anchor else { return }

        let parts = key.split(separator: "_")
        let x = Int(parts[0])!
        let z = Int(parts[1])!
        let layer = heights[key] ?? 0

        let cube = ModelEntity(
            mesh: .generateBox(size: cubeSize),
            materials: [SimpleMaterial(color: selectedColor, isMetallic: false)]
        )

        cube.position = position
        cube.name = "cell_\(x)_\(z)_\(layer)"
        cube.generateCollisionShapes(recursive: false)

        anchor.addChild(cube)
        columns[key, default: []].append(cube)

        heights[key] = (heights[key] ?? 0) + 1
    }

    // Remove um cubo
    func removeSpecificCube(entity: Entity, key: String) {
        guard var list = columns[key] else { return }

        // 1. Encontra o cubo específico na lista da coluna
        // Usamos 'firstIndex' comparando as referências dos objetos
        guard let index = list.firstIndex(where: { $0 === entity }) else { return }

        // 2. Remove visualmente da cena (sem mover os outros = flutuante)
        entity.removeFromParent()
        
        // 3. Remove da lista de dados
        list.remove(at: index)
        columns[key] = list

        // 4. Recalcula a altura da coluna (heights)
        // Isso é CRUCIAL para evitar bugs ao adicionar novos blocos nessa coluna depois.
        // A nova altura deve ser baseada no cubo mais alto que sobrou + 1.
        
        if list.isEmpty {
            heights[key] = 0
        } else {
            // Descobre qual é o cubo mais alto que restou (baseado na posição Y)
            let maxY = list.map { $0.position.y }.max() ?? 0
            
            // Converte a posição Y de volta para índice de "layer" (aproximado)
            // Fórmula inversa de: posY = (cubeSize / 2) + (layer * cubeSize)
            let topLayerIndex = Int((maxY - (cubeSize / 2)) / cubeSize)
            
            heights[key] = topLayerIndex + 1
        }
        
        // Debug opcional para verificar se a altura ficou correta
        // print("Cubo removido. Nova altura da coluna \(key): \(heights[key] ?? 0)")
    }
    
    // Limpa todos os cubos da cena
    func clearAllCubes() {
           for (_, cubeList) in columns {
               cubeList.forEach { $0.removeFromParent() }
           }

           columns.removeAll()
           heights.removeAll()
           activePreviews.removeAll()
       }

    // MARK: Pré-visualização de adjacentes

    func showPreviewCubes(for x: Int, y: Int, z: Int, color: UIColor) {
        removeActivePreviews()
        guard let anchor = anchor else { return }

        let directions: [(dx: Int, dy: Int, dz: Int)] = [
            (0, 1, 0),
            (0, -1, 0),
            (-1, 0, 0),
            (1, 0, 0),
            (0, 0, -1),
            (0, 0, 1)
        ]

        for dir in directions {
            let nx = x + dir.dx
            let nz = z + dir.dz
            let ny = y + dir.dy

            guard nx >= 0, nx < gridSize, nz >= 0, nz < gridSize else { continue }
            guard ny >= 0 else { continue }

            let keyNeighbor = "\(nx)_\(nz)"
            let currentHeight = heights[keyNeighbor] ?? 0

            if ny < currentHeight { continue }
            if ny > gridSize - 1 { continue }

            let posY = (cubeSize / 2) + (Float(ny) * cubeSize)
            let pos = SIMD3<Float>(
                Float(nx) * (cubeSize + gap) - baseOffset,
                posY,
                Float(nz) * (cubeSize + gap) - baseOffset
            )

            let preview = createPreviewCube(at: pos, key: keyNeighbor, color: color)
            anchor.addChild(preview)
            activePreviews.append(preview)
        }
    }

    func removeActivePreviews() {
        activePreviews.forEach { $0.removeFromParent() }
        activePreviews.removeAll()
    }

    func createPreviewCube(at position: SIMD3<Float>, key: String, color: UIColor, size: Float = 0.1) -> ModelEntity {
        let material = SimpleMaterial(color: color.withAlphaComponent(0.4), isMetallic: false)
        let cube = ModelEntity(mesh: .generateBox(size: size), materials: [material])

        cube.position = position
        cube.name = "preview_\(UUID().uuidString)"
        cube.components[PreviewCubeComponent.self] = PreviewCubeComponent(key: key)
        cube.generateCollisionShapes(recursive: false)

        return cube
    }
}
