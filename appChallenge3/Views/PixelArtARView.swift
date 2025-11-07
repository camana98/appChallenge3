//
//  PixelArtARView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI
import ARKit
import RealityKit

struct PixelArtARView: UIViewRepresentable {
    let pixels: [[Color]]
    let gridSize: Int
    @Binding var scale: Float
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configurar a sessão AR
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        // Desabilitar environmentTexturing para reduzir warnings
        // config.environmentTexturing = .automatic
        
        arView.session.run(config)
        
        // Configurar coordenador para toques
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:))))
        
        // Adicionar o pixel art ao mundo AR
        setupPixelArt(in: arView, coordinator: context.coordinator)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Atualizar escala se necessário
        if let entity = context.coordinator.pixelArtEntity {
            entity.scale = SIMD3<Float>(repeating: scale)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: PixelArtARView
        var pixelArtAnchor: AnchorEntity?
        var pixelArtEntity: Entity?
        
        init(_ parent: PixelArtARView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARView else { return }
            
            let location = gesture.location(in: arView)
            
            // Realizar raycast para encontrar um plano (horizontal ou vertical)
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
            
            if let result = results.first {
                // Reposicionar o pixel art
                if let anchor = pixelArtAnchor {
                    // Criar nova posição baseada no resultado do raycast
                    let transform = result.worldTransform
                    let position = SIMD3<Float>(
                        transform.columns.3.x,
                        transform.columns.3.y,
                        transform.columns.3.z
                    )
                    
                    // Atualizar a posição do anchor
                    anchor.position = position
                    
                    // Ajustar a rotação baseado no tipo de plano
                    if result.targetAlignment == .vertical {
                        // Para plano vertical (parede), calcular rotação para ficar alinhado com a parede
                        let normal = SIMD3<Float>(
                            transform.columns.2.x,
                            transform.columns.2.y,
                            transform.columns.2.z
                        )
                        
                        // Calcular direção para onde o quadro deve olhar (oposto à normal do plano)
                        let lookDirection = -normal
                        
                        // Calcular rotação para olhar nessa direção
                        // Usar a matriz de transformação diretamente
                        let col0 = transform.columns.0
                        let col1 = transform.columns.1
                        let col2 = transform.columns.2
                        let rotationMatrix = simd_float3x3(
                            SIMD3<Float>(col0.x, col0.y, col0.z),
                            SIMD3<Float>(col1.x, col1.y, col1.z),
                            SIMD3<Float>(col2.x, col2.y, col2.z)
                        )
                        let rotation = simd_quatf(rotationMatrix)
                        
                        // Aplicar rotação adicional de 90 graus no eixo X para o quadro ficar vertical
                        let xRotation = simd_quatf(angle: Float.pi / 2, axis: SIMD3<Float>(1, 0, 0))
                        anchor.orientation = rotation * xRotation
                    } else {
                        // Para plano horizontal, manter rotação padrão (vertical na parede imaginária)
                        // Rotação de 90 graus no eixo X para ficar vertical
                        anchor.orientation = simd_quatf(angle: Float.pi / 2, axis: SIMD3<Float>(1, 0, 0))
                    }
                }
            }
        }
    }
    
    private func setupPixelArt(in arView: ARView, coordinator: Coordinator) {
        // Criar um anchor para o pixel art inicialmente na frente da câmera
        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, -1.0))
        
        // Criar o plano 2D do pixel art (como um quadro)
        let pixelArtEntity = createPixelArtPlane(
            pixels: pixels,
            gridSize: gridSize
        )
        
        // Aplicar escala inicial
        pixelArtEntity.scale = SIMD3<Float>(repeating: scale)
        
        // Rotacionar para ficar vertical (como um quadro na parede)
        // Rotação de 90 graus no eixo X para ficar vertical
        pixelArtEntity.orientation = simd_quatf(angle: Float.pi / 2, axis: SIMD3<Float>(1, 0, 0))
        
        anchor.addChild(pixelArtEntity)
        arView.scene.addAnchor(anchor)
        
        coordinator.pixelArtAnchor = anchor
        coordinator.pixelArtEntity = pixelArtEntity
    }
    
    private func createPixelArtPlane(
        pixels: [[Color]],
        gridSize: Int
    ) -> Entity {
        let container = Entity()
        
        // Tamanho de cada pixel em metros (no plano 2D)
        let pixelSize: Float = 0.015 // 1.5cm por pixel
        let spacing: Float = 0.001 // 1mm de espaçamento entre pixels
        
        // Calcular o tamanho total do grid
        let totalWidth = Float(gridSize) * pixelSize + Float(gridSize - 1) * spacing
        let totalHeight = Float(gridSize) * pixelSize + Float(gridSize - 1) * spacing
        let startX = -totalWidth / 2 + pixelSize / 2
        let startY = -totalHeight / 2 + pixelSize / 2
        
        // Criar cada pixel como um quadrado 2D em um plano
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let color = pixels[row][col]
                
                // Criar um material colorido
                var material = SimpleMaterial()
                material.color = .init(tint: UIColor(color))
                material.metallic = 0.0
                material.roughness = 0.5
                
                // Criar um plano (quadrado) para cada pixel
                let mesh = MeshResource.generatePlane(width: pixelSize, depth: pixelSize)
                let pixelEntity = ModelEntity(mesh: mesh, materials: [material])
                
                // Calcular a posição do pixel no plano
                let x = startX + Float(col) * (pixelSize + spacing)
                let y = startY + Float(row) * (pixelSize + spacing)
                
                // Posicionar no plano XY (Z será 0, pois é um plano)
                pixelEntity.position = SIMD3<Float>(x, y, 0)
                
                container.addChild(pixelEntity)
            }
        }
        
        return container
    }
}


