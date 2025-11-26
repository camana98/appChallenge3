import Foundation
import SwiftUI
import RealityKit
import Combine
import ARKit

class UnifiedCoordinator: NSObject, UIGestureRecognizerDelegate {

    weak var arView: ARView?
    var anchor: AnchorEntity?
    var modelEntity: Entity?

    let gridSize = 10
    let cubeSize: Float = 0.1
    let gap: Float = 0.0
    let gridLineWidth: Float = 0.002

    var baseOffset: Float {
        (Float(gridSize) * (cubeSize + gap)) / 2.0 - cubeSize / 2.0
    }

    var heights: [String: Int] = [:]
    var columns: [String: [ModelEntity]] = [:]

    var currentRotationY: Float = 0
    var currentScale: Float = 1.0
    var lastTranslation = CGPoint.zero

    var removeMode: Bool = false
    var selectedColor: UIColor = .lightGray
    var activePreviews: [ModelEntity] = []

    var usdzScale: Float = 1.0
    var usdzOffset: SIMD3<Float> = .zero

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
            print("❌ Erro ao carregar o modelo \(fileName): \(error.localizedDescription)")
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

            let vLineMesh = MeshResource.generateBox(size: [gridLineWidth, gridLineWidth, totalLength])
            let vLine = ModelEntity(mesh: vLineMesh, materials: [lineMaterial])
            vLine.position = [offset, lineHeight, 0]
            anchor.addChild(vLine)

            let hLineMesh = MeshResource.generateBox(size: [totalLength, gridLineWidth, gridLineWidth])
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

    // MARK: - Gestures

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        let translation = gesture.translation(in: arView)
        if gesture.state == .began {
            lastTranslation = translation
        }

        let deltaX = Float(translation.x - lastTranslation.x)
        let deltaY = Float(translation.y - lastTranslation.y)

        currentRotationY += deltaX * 0.01
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
        currentScale = max(0.4, min(currentScale, 3.5))

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
                // adiciona exatamente onde o preview está
                addCube(at: entity.position, key: preview.key)
                removeActivePreviews()
            }
            return
        }

        removeActivePreviews()

        if entity.name.starts(with: "base_") {
            if !removeMode, let parsed = parseBaseName(entity.name) {
                addCube(atKey: "\(parsed.x)_\(parsed.z)", fromBase: true)
            }
            return
        }

        if let parsed = parseCellName(entity.name) {
            if removeMode {
                removeTopCube(in: "\(parsed.x)_\(parsed.z)")
            } else {
                // pegar altura real do cubo clicado
                if let currentCube = arView.entity(at: gesture.location(in: arView)) {
                    showPreviewCubes(
                        for: parsed.x,
                        y: Int(currentCube.position.y / cubeSize), // altura real do cubo
                        z: parsed.z,
                        color: selectedColor
                    )
                }
            }
        }

    }

    // MARK: - Parse helpers

    func parseBaseName(_ name: String) -> (x: Int, z: Int)? {
        let parts = name.split(separator: "_")
        guard parts.count == 3, parts[0] == "base",
              let x = Int(parts[1]), let z = Int(parts[2])
        else { return nil }
        return (x, z)
    }

    func parseCellName(_ name: String) -> (x: Int, z: Int, layer: Int)? {
        let parts = name.split(separator: "_")
        guard parts.count == 4, parts[0] == "cell",
              let x = Int(parts[1]), let z = Int(parts[2]), let layer = Int(parts[3])
        else { return nil }
        return (x, z, layer)
    }

    // MARK: - Cube management

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


    func removeTopCube(in key: String) {
        guard var list = columns[key], list.count > 0 else { return }

        let top = list.removeLast()
        top.removeFromParent()

        columns[key] = list
        heights[key] = max(0, (heights[key] ?? 0) - 1)
    }

    // MARK: - Arrows for adjacency

    func showPreviewCubes(for x: Int, y: Int, z: Int, color: UIColor) {
        removeActivePreviews()
        guard let anchor = anchor else { return }

        // DIREÇÕES: todas as 6 adjacências (dx, dy, dz)
        let directions: [(dx: Int, dy: Int, dz: Int)] = [
            (0, 1, 0),   // cima
            (0, -1, 0),  // baixo
            (-1, 0, 0),  // esquerda
            (1, 0, 0),   // direita
            (0, 0, -1),  // trás
            (0, 0, 1)    // frente
        ]

        for dir in directions {
            let nx = x + dir.dx
            let nz = z + dir.dz
            let ny = y + dir.dy

            // ❌ ignora fora do grid
            guard nx >= 0, nx < gridSize, nz >= 0, nz < gridSize else { continue }
            // ❌ ignora posições abaixo do chão
            guard ny >= 0 else { continue }

            let keyNeighbor = "\(nx)_\(nz)"
            let currentHeight = heights[keyNeighbor] ?? 0

            // ❌ ignora se já houver cubo nessa altura
            if ny < currentHeight { continue }

            // ❌ ignora se a altura máxima for alcançada
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
        
        // cria material semi-transparente usando a cor passada
        let material = SimpleMaterial(color: color.withAlphaComponent(0.4), isMetallic: false)
        let cube = ModelEntity(mesh: .generateBox(size: size), materials: [material])
        
        cube.position = position
        cube.name = "preview_\(UUID().uuidString)"
        
        // adiciona componente de dados
        cube.components[PreviewCubeComponent.self] = PreviewCubeComponent(key: key)
        
        cube.generateCollisionShapes(recursive: false)
        
        return cube
    }



    // MARK: - Camera

    func updateCameraPosition(animated: Bool) {
        guard let anchor = anchor else { return }

        let radius: Float = 1.5 * currentScale
        let fixedPitch: Float = .pi / 6

        let camX = radius * sin(currentRotationY)
        let camY = radius * sin(fixedPitch)
        let camZ = radius * cos(currentRotationY)

        let targetPosition = SIMD3<Float>(camX, camY, camZ)

        anchor.children.filter { $0.name == "camera" }.forEach { $0.removeFromParent() }

        let cameraEntity = PerspectiveCamera()
        cameraEntity.name = "camera"
        cameraEntity.look(at: .zero, from: targetPosition, relativeTo: nil)

        if animated {
            let move = Transform(
                scale: .one,
                rotation: simd_quatf(),
                translation: targetPosition
            )
            cameraEntity.move(
                to: move,
                relativeTo: nil,
                duration: 0.15,
                timingFunction: .easeInOut
            )
        } else {
            cameraEntity.position = targetPosition
        }

        anchor.addChild(cameraEntity)
    }

    // MARK: - Utilities

    func updateRotation(_ value: Float) {
        currentRotationY = value
        updateCameraPosition(animated: false)
    }

    func updateCamera(animated: Bool = false) {
        updateCameraPosition(animated: animated)
    }

    // Allow gestures at same time
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}
