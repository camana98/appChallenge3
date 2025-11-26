//
//  ComponentExample.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI
import RealityKit

struct CubeButtonComponent: View {
    
    var cubeStyle: CubeStyle
    var cubeColor: CubeColor
    
    var action: () -> Void
    
    private let cubeSize: Float = 0.7
    private let iconSize: Float = 0.7 * 0.85
    
    var body: some View {
        RealityView { content in
            let cubeMesh = MeshResource.generateBox(size: cubeSize, cornerRadius: 0)
            
            var cubeMaterial = SimpleMaterial()
            cubeMaterial.color = .init(tint: cubeColor.color)
            cubeMaterial.roughness = 0.6
            cubeMaterial.metallic = 0.3
            
            let cubeEntity = ModelEntity(mesh: cubeMesh, materials: [cubeMaterial])
            
            let rotationBox = simd_quatf(angle: .pi / 4, axis: [ 0.5 , 0, 0]) *
            simd_quatf(angle: -0.5, axis: [0, 1, 0 ])
            
            cubeEntity.transform.rotation = rotationBox
            
            cubeEntity.generateCollisionShapes(recursive: false)
            cubeEntity.components.set(InputTargetComponent())
            
            let planeMesh = MeshResource.generatePlane(width: iconSize, height: iconSize)
            
            var planeMaterial = UnlitMaterial()
            
            if let texture = generateTextureFromAsset(image: cubeStyle.image, color: cubeStyle.color) {
                planeMaterial.color = .init(texture: .init(texture))
                planeMaterial.blending = .transparent(opacity: 1.0)
            } else {
                print("Textura não encontrada.")
                planeMaterial.color = .init(tint: .red.withAlphaComponent(0.5))
            }
            
            let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
            
            planeEntity.position = SIMD3<Float>(0, 0, (cubeSize / 2) + 0.02)
            planeEntity.orientation = simd_quatf(angle: .pi / 2 , axis: [0, 0, 0])
            
            cubeEntity.addChild(planeEntity)
            
            cubeEntity.generateCollisionShapes(recursive: true)
            cubeEntity.components.set(InputTargetComponent())
            
            content.add(cubeEntity)
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { _ in
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    action()
                }
        )
    }
    
    func generateTextureFromAsset(image: UIImage, color: UIColor) -> TextureResource? {
        
        let uiImage = image.withTintColor(color)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 600, height: 600))
        let textureImage = renderer.image { ctx in
            let width = uiImage.size.width
            let height = uiImage.size.height
            let ratio = min(600 / width, 600 / height)
            let newWidth = width * ratio
            let newHeight = height * ratio
            
            let imageRect = CGRect(
                x: (600 - newWidth) / 2,
                y: (600 - newHeight) / 2,
                width: newWidth,
                height: newHeight
            )
            uiImage.draw(in: imageRect)
        }
        
        guard let cgImage = textureImage.cgImage else { return nil }
        return try? TextureResource(image: cgImage, options: .init(semantic: .color))
    }
}

enum CubeColor: CaseIterable {
    case green
    case red
    case blue
    case white
    
    var color: UIColor {
        switch self {
        case .blue: return .customBlue
        case .white: return .customWhite
        case .red: return .customRed
        case .green: return .customGreen
        }
    }
}

enum CubeStyle: CaseIterable {
    case xmark
    case checkmark
    case toolbox
    case rollback
    case rollfront
    case addCube
    case demolish
    case cleanAll
    case altColor
    case back
    case heart
    case map
    case pencil
    case grid
    
    var image: UIImage{
        switch self {
        case .xmark: return .xmark1
        case .checkmark: return .checkmark1
        case .toolbox: return .wrenchAndScrewdriverFill
        case .rollback: return .arrowUturnBackward
        case .rollfront: return .arrowUturnForward
        case .addCube: return .group1
        case .demolish: return .hammerFill
        case .cleanAll: return .xmarkBinFill
        case .altColor: return .paintbrushPointedFill
        case .back: return .chevronLeft1
        case .heart: return .heartFill1
        case .map: return .mappinAndEllipse1
        case .pencil: return .pencil1
        case .grid: return .squareGrid3X31
        }
    }
    
    var color: UIColor {
        switch self {
        case .xmark: return .customWhite
        case .checkmark: return .customWhite
        case .toolbox: return .customWhite
        case .rollback: return .customBlue
        case .rollfront: return .customBlue
        case .addCube: return .customWhite
        case .demolish: return .customWhite
        case .cleanAll: return .customWhite
        case .altColor: return .customWhite
        case .back: return .customWhite
        case .heart: return .customWhite
        case .map: return .customWhite
        case .pencil: return .customWhite
        case .grid: return .customWhite
        }
    }
}

#Preview {
    VStack {
        CubeButtonComponent(cubeStyle: .checkmark, cubeColor: .blue) {
            print("hehehe")
        }
    }
}
