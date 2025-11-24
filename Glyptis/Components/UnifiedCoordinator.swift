import Foundation
import SwiftUI
import RealityKit
import Combine
import ARKit

// MARK: - Unified Coordinator
class UnifiedCoordinator: NSObject, UIGestureRecognizerDelegate {
    weak var arView: ARView?
    var anchor: AnchorEntity?
    var modelEntity: Entity?

    // Configurações do Grid
    // Configurações do Grid
        let gridSize = 10
        let cubeSize: Float = 0.1
        let gap: Float = 0.0 // 👈 AGORA É ZERO
        
        // 👇 Nova constante para a espessura da linha
        let gridLineWidth: Float = 0.002
        
        var baseOffset: Float {
            (Float(gridSize) * (cubeSize + gap)) / 2.0 - cubeSize / 2.0
        }
    
    // Dados do Grid
    var heights: [String: Int] = [:]
    var columns: [String: [ModelEntity]] = [:]
    
    // Câmera e Interação
    var currentRotationY: Float = 0
    var currentScale: Float = 1.0
    var lastTranslation = CGPoint.zero
    
    // Estados vindos da View
    var removeMode: Bool = false
    var selectedColor: UIColor = .lightGray
    var activeArrows: [ModelEntity] = []
    
    // Configurações do Modelo de Referência (USDZ)
    var usdzScale: Float = 1.0
    var usdzOffset: SIMD3<Float> = .zero

    func setupGridLines(anchor: AnchorEntity) {
            let totalLength = Float(gridSize) * cubeSize
            let halfLength = totalLength / 2.0
            
            // Material das linhas (Preto fosco)
            let lineMaterial = SimpleMaterial(color: .black.withAlphaComponent(0.5), isMetallic: false)
            
            // Altura levemente acima do chão para não "piscar" (Z-fighting) com a base
            // Como a base está em -cubeSize/2 e tem altura cubeSize, o topo é 0.
            // Colocamos em 0.001
            let lineHeight: Float = 0.001
            
            // Loop para criar as linhas (GridSize + 1 para fechar as bordas finais)
            for i in 0...gridSize {
                let offset = Float(i) * cubeSize - halfLength
                
                // --- Linhas Verticais (ao longo de Z) ---
                let vLineMesh = MeshResource.generateBox(size: [gridLineWidth, gridLineWidth, totalLength])
                let vLine = ModelEntity(mesh: vLineMesh, materials: [lineMaterial])
                
                // Posição: X varia, Y fixo, Z centro
                vLine.position = [offset, lineHeight, 0]
                anchor.addChild(vLine)
                
                // --- Linhas Horizontais (ao longo de X) ---
                let hLineMesh = MeshResource.generateBox(size: [totalLength, gridLineWidth, gridLineWidth])
                let hLine = ModelEntity(mesh: hLineMesh, materials: [lineMaterial])
                
                // Posição: X centro, Y fixo, Z varia
                hLine.position = [0, lineHeight, offset]
                anchor.addChild(hLine)
            }
        }
    
    func updateModelTransform() {
        // Verifica se o modelo já foi carregado
        guard let model = modelEntity else { return }
        
        // Aplica os novos valores imediatamente
        model.transform.translation = usdzOffset
        model.transform.scale = SIMD3<Float>(usdzScale, usdzScale, usdzScale)
    }
    // MARK: - Setup Inicial
    func setupScene(anchor: AnchorEntity, usdzFileName: String) {
            self.anchor = anchor
            
            setupLight(anchor: anchor)
            loadReferenceModel(fileName: usdzFileName, anchor: anchor)
            
            setupGrid(anchor: anchor)
            
            // 👇 ADICIONE ESTA LINHA AQUI
            setupGridLines(anchor: anchor)
            
            updateCameraPosition(animated: false)
        }

    func loadReferenceModel(fileName: String, anchor: AnchorEntity) {
        // Evita carregar se já estiver carregado ou nome vazio
        guard !fileName.isEmpty, modelEntity == nil else { return }
        
        do {
            let loadedEntity = try Entity.load(named: fileName)
            
            // Aplica as transformações do seu código original
            loadedEntity.transform.scale = SIMD3<Float>(usdzScale, usdzScale, usdzScale)
            loadedEntity.transform.translation = usdzOffset
            
            // Define um nome para não confundir com os cubos no Raycast
            loadedEntity.name = "reference_model"
            
            // Adiciona como filho da âncora principal
            anchor.addChild(loadedEntity)
            self.modelEntity = loadedEntity
            print("✅ Modelo \(fileName) carregado com sucesso.")
            
        } catch {
            print("❌ Erro ao carregar o modelo \(fileName): \(error.localizedDescription)")
            // Opcional: Adicionar um placeholder caso falhe
            let placeholder = ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: false)])
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

    
    func setupLight(anchor: AnchorEntity) {
        let light = DirectionalLight()
        light.light.intensity = 1500
        light.orientation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0])
        anchor.addChild(light)
    }
    
    // MARK: - Gestos de Câmera (Mantidos do seu código)
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let arView = arView else { return }
        let translation = gesture.translation(in: arView)
        if gesture.state == .began { lastTranslation = translation }

        let deltaX = Float(translation.x - lastTranslation.x)
        let deltaY = Float(translation.y - lastTranslation.y)

        currentRotationY += deltaX * 0.01
        updateCameraPosition(animated: false)
        
        // Move a âncora para cima/baixo
        anchor?.position.y -= deltaY * 0.005

        lastTranslation = translation
        if gesture.state == .ended { lastTranslation = .zero }
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.state == .changed else { return }
        let pinchDelta = Float(gesture.scale - 1.0) * 0.3
        currentScale -= pinchDelta
        currentScale = max(0.4, min(currentScale, 3.5))
        updateCameraPosition(animated: true)
        gesture.scale = 1.0
    }
    
    func updateCameraPosition(animated: Bool) {
        guard let anchor = anchor else { return }
        let radius: Float = 1.5 * currentScale
        let fixedPitch: Float = .pi / 6
        
        let camX = radius * sin(currentRotationY)
        let camY = radius * sin(fixedPitch)
        let camZ = radius * cos(currentRotationY)
        
        let targetPosition = SIMD3<Float>(camX, camY, camZ)
        
        // Remove câmera antiga
        anchor.children.filter { $0.name == "camera" }.forEach { $0.removeFromParent() }
        
        let cameraEntity = PerspectiveCamera()
        cameraEntity.name = "camera"
        cameraEntity.look(at: .zero, from: targetPosition, relativeTo: nil)
        
        if animated {
            let move = Transform(scale: .one, rotation: simd_quatf(), translation: targetPosition)
            cameraEntity.move(to: move, relativeTo: nil, duration: 0.15, timingFunction: .easeInOut)
        } else {
            cameraEntity.position = targetPosition
        }
        
        anchor.addChild(cameraEntity)
    }
    
    // MARK: - Lógica de Tap (Adicionar/Remover Cubos)
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        let location = gesture.location(in: arView)
        
        // Raycast
        guard let entity = arView.entity(at: location) else {
            removeActiveArrows()
            return
        }
        
        // Se clicar no modelo de referência (coluna), não faz nada ou limpa seleção
        if entity.name == "reference_model" {
            removeActiveArrows()
            return
        }
        
        // Lógica de Seta
        if entity.name.starts(with: "arrow_") {
            if let pos = entity.components[ArrowComponent.self]?.position {
                addCube(at: pos)
                removeActiveArrows()
            }
            return
        }
        
        removeActiveArrows()
        
        // Lógica da Base
        if entity.name.starts(with: "base_") {
            if !removeMode, let parsed = parseBaseName(entity.name) {
                // Adiciona o primeiro cubo em cima da base
                addCube(atKey: "\(parsed.x)_\(parsed.z)", fromBase: true)
            }
            return
        }
        
        // Lógica de Célula existente
        if let parsed = parseCellName(entity.name) {
            if removeMode {
                removeTopCube(in: "\(parsed.x)_\(parsed.z)")
            } else {
                showArrows(for: parsed.x, y: parsed.layer, z: parsed.z)
            }
        }
    }

    // ... (Métodos auxiliares parseBaseName, parseCellName mantidos iguais) ...
    func parseBaseName(_ name: String) -> (x: Int, z: Int)? {
        let parts = name.split(separator: "_")
        guard parts.count == 3, parts[0] == "base",
              let x = Int(parts[1]), let z = Int(parts[2]) else { return nil }
        return (x, z)
    }
    
    func parseCellName(_ name: String) -> (x: Int, z: Int, layer: Int)? {
        let parts = name.split(separator: "_")
        guard parts.count == 4, parts[0] == "cell",
              let x = Int(parts[1]), let z = Int(parts[2]), let layer = Int(parts[3]) else { return nil }
        return (x, z, layer)
    }
    
    // MARK: - Manipulação de Cubos
    func addCube(atKey key: String, fromBase: Bool = false) {
        let parts = key.split(separator: "_")
        guard parts.count == 2, let x = Int(parts[0]), let z = Int(parts[1]) else { return }
        
        let currentHeight = heights[key] ?? 0
        
        // Calcula posição. Se for da base, height é 0.
        let posY = (cubeSize / 2) + (Float(currentHeight) * cubeSize) - (fromBase ? 0 : 0)
        
        let posX = Float(x) * (cubeSize + gap) - baseOffset
        let posZ = Float(z) * (cubeSize + gap) - baseOffset
        
        addCube(at: SIMD3<Float>(posX, posY, posZ), key: key)
    }
    
    func addCube(at position: SIMD3<Float>, key: String? = nil) {
        guard let anchor = anchor else { return }
        
        // Tenta inferir a chave pela posição se não fornecida (simplificado)
        // Idealmente passamos a chave. Aqui assumimos que 'key' vem populado das funcões acima.
        guard let keyStr = key else { return } // Simplificação para brevidade
        let parts = keyStr.split(separator: "_")
        let x = Int(parts[0])!
        let z = Int(parts[1])!
        let layer = heights[keyStr] ?? 0
        
        let cube = ModelEntity(
            mesh: .generateBox(size: cubeSize),
            materials: [SimpleMaterial(color: selectedColor, isMetallic: false)]
        )
        cube.position = position
        cube.name = "cell_\(x)_\(z)_\(layer)"
        cube.generateCollisionShapes(recursive: false)
        anchor.addChild(cube)
        
        columns[keyStr, default: []].append(cube)
        heights[keyStr] = (heights[keyStr] ?? 0) + 1
    }
    
    func removeTopCube(in key: String) {
        guard var list = columns[key], list.count > 0 else { return } // > 0 pois agora permitimos remover até o chão
        let top = list.removeLast()
        top.removeFromParent()
        columns[key] = list
        heights[key] = max(0, (heights[key] ?? 0) - 1)
    }

    // ... (Métodos showArrows, removeActiveArrows e ArrowComponent mantidos iguais) ...
    func showArrows(for x: Int, y: Int, z: Int) {
         guard let anchor = anchor else { return }
         
         let directions: [SIMD3<Float>] = [
             [0, 1, 0],   // cima
             [0, -1, 0],  // baixo
             [-1, 0, 0],  // esquerda
             [1, 0, 0],   // direita
             [0, 0, -1],  // frente
             [0, 0, 1]    // trás
         ]
         
        // Busca o cubo exato
         guard let currentCube = anchor.children.first(where: { $0.name == "cell_\(x)_\(z)_\(y)" }) else { return }
         let origin = currentCube.position
         
         for dir in directions {
             let targetPos = origin + dir * cubeSize
             // Impede setas para baixo do chão (y < 0 visualmente)
             if dir.y < 0, targetPos.y < 0 { continue }
             
             let arrow = ModelEntity(
                 mesh: .generateBox(size: 0.05),
                 materials: [SimpleMaterial(color: .yellow, isMetallic: false)]
             )
             arrow.position = targetPos
             arrow.name = "arrow_\(UUID().uuidString)"
             arrow.generateCollisionShapes(recursive: false)
             arrow.components[ArrowComponent.self] = ArrowComponent(position: targetPos)
             anchor.addChild(arrow)
             activeArrows.append(arrow)
         }
     }
     
     func removeActiveArrows() {
         activeArrows.forEach { $0.removeFromParent() }
         activeArrows.removeAll()
     }
     
     struct ArrowComponent: Component {
         var position: SIMD3<Float>
     }
     
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
