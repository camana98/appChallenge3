//
//  UnifiedCoordinator+Setup.swift.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

internal import RealityKit
import Foundation
internal import UIKit

extension UnifiedCoordinator {

    // MARK: - Setup

    func setupScene(anchor: AnchorEntity, usdzFileName: String) {
        self.anchor = anchor

        setupLight(anchor: anchor)
        loadReferenceModel(fileName: usdzFileName, anchor: anchor)
        setupGrid(anchor: anchor)
        setupGridLines(anchor: anchor)
        updateCameraPosition(animated: false)
    }

    func loadReferenceModel(fileName: String, anchor: AnchorEntity) {
        guard !fileName.isEmpty, modelEntity == nil else { return }

        do {
            let loadedEntity = try Entity.load(named: fileName)
            loadedEntity.transform.scale = SIMD3<Float>(usdzScale, usdzScale, usdzScale)
            loadedEntity.transform.translation = usdzOffset
            loadedEntity.name = "reference_model"
            anchor.addChild(loadedEntity)
            self.modelEntity = loadedEntity

        } catch {
            print("Erro: \(fileName): \(error.localizedDescription)")
            let placeholder = ModelEntity(
                mesh: .generateSphere(radius: 0.1),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )
            placeholder.position = usdzOffset
            anchor.addChild(placeholder)
        }
    }

    func setupGrid(anchor: AnchorEntity) {
        for x in 0..<gridSize {
            for z in 0..<gridSize {

                let posX = Float(x) * (cubeSize + gap) - baseOffset
                let posZ = Float(z) * (cubeSize + gap) - baseOffset

                var material = SimpleMaterial()
                material.color = .init(tint: .clear, texture: nil)

                let plane = ModelEntity(
                    mesh: .generatePlane(width: cubeSize, depth: cubeSize),
                    materials: [material]
                )

                plane.position = [posX, 0.0, posZ]
                plane.name = "base_\(x)_\(z)"
                plane.generateCollisionShapes(recursive: false)
                anchor.addChild(plane)

                let key = "\(x)_\(z)"
                heights[key] = 0
                columns[key] = []
            }
        }
    }

    func setupGridLines(anchor: AnchorEntity) {
        let totalLength = Float(gridSize) * cubeSize
        let halfLength = totalLength / 2.0
        let lineMaterial = SimpleMaterial(color: .black.withAlphaComponent(0.5), isMetallic: false)
        let lineHeight: Float = 0.001

        for i in 0...gridSize {
            let offset = Float(i) * cubeSize - halfLength

            let vLineMesh = MeshResource.generateBox(size: [gridLineWidth, lineHeight, totalLength])
            let vLine = ModelEntity(mesh: vLineMesh, materials: [lineMaterial])
            vLine.position = [offset, lineHeight, 0]
            anchor.addChild(vLine)

            let hLineMesh = MeshResource.generateBox(size: [totalLength, lineHeight, gridLineWidth])
            let hLine = ModelEntity(mesh: hLineMesh, materials: [lineMaterial])
            hLine.position = [0, lineHeight, offset]
            anchor.addChild(hLine)
        }
    }

    func setupLight(anchor: AnchorEntity) {
        let light = DirectionalLight()
        light.light.intensity = 1500
        light.orientation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0])
        anchor.addChild(light)
    }
}
