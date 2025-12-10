//
//  ARViewCoordinator.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import ARKit
internal import RealityKit
import Foundation
import SwiftUI

class ARViewCoordinator: NSObject, ARSessionDelegate, UIGestureRecognizerDelegate {
    
    static let shared = ARViewCoordinator()
    
    var onTrackingStateChanged: ((String?) -> Void)?
    
    var arView: ARView
    var previewAnchor: AnchorEntity?
    var activeSculpture: Sculpture?
    var selectedEntityForHeight: ModelEntity?
    
    var onAnchorLongPressed: ((ARAnchor) -> Void)?
    var onEntitySelected: ((Float, Float) -> Void)?
    var onSelectionCleared: (() -> Void)?
    
    private var worldMapURL: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("glyptisWorldMap")
        } catch {
            fatalError("Erro ao criar URL do mapa AR")
        }
    }()
    
    private override init() {
        self.arView = ARView(frame: .zero)
        super.init()
        setupARView()
    }
    
    private func setupARView() {
            arView.automaticallyConfigureSession = false
            
            let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.horizontal, .vertical]
            config.environmentTexturing = .automatic
            
            if let savedMap = retrieveWorldMap() {
                config.initialWorldMap = savedMap
                print("Mapa AR carregado com sucesso. O ARKit tentará relocalizar.")
            }
            
            arView.session.delegate = self
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.delegate = self
            arView.addGestureRecognizer(tapGesture)
            
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            longPressGesture.delegate = self
            arView.addGestureRecognizer(longPressGesture)
            
            arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: arView)
        if let hitEntity = arView.entity(at: location) {
            if let sculptureRoot = hitEntity.findSculptureRoot() {
                self.selectedEntityForHeight = sculptureRoot
                
                let currentRotation = sculptureRoot.transform.rotation.angle
                
                onEntitySelected?(sculptureRoot.position.y, currentRotation)
                return
            }
        }
        self.selectedEntityForHeight = nil
        onSelectionCleared?()
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let location = sender.location(in: arView)
        if let entity = arView.entity(at: location) {
            if let anchorEntity = entity.findAnchorEntity(),
               let identifier = anchorEntity.anchorIdentifier,
               let anchor = arView.session.currentFrame?.anchors.first(where: { $0.identifier == identifier }) {
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                onAnchorLongPressed?(anchor)
            }
        }
    }
    
    func updateHeight(to newHeight: Float) {
        guard let entity = selectedEntityForHeight else { return }
        entity.position.y = newHeight
    }
    
    func updateRotation(to angleRadians: Float) {
        guard let entity = selectedEntityForHeight else { return }
        entity.transform.rotation = simd_quatf(angle: angleRadians, axis: [0, 1, 0])
    }
    
    func remove(anchor: ARAnchor) {
        arView.session.remove(anchor: anchor)
        if let selectedEntity = selectedEntityForHeight,
           let anchorEntity = selectedEntity.findAnchorEntity(),
           anchorEntity.anchorIdentifier == anchor.identifier {
            selectedEntityForHeight = nil
            onSelectionCleared?()
        }
        
        self.saveWorldMap()
    }
    
    // MARK: - Persistence & Setup
    
    func saveWorldMap() {
        arView.session.getCurrentWorldMap { map, error in
            guard let map = map else { return }
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.worldMapURL)
            } catch { print("Erro ao salvar mapa: \(error.localizedDescription)") }
        }
    }
    
    private func retrieveWorldMap() -> ARWorldMap? {
        guard let data = try? Data(contentsOf: worldMapURL) else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) as? ARWorldMap
    }
    
    func showPreview(of sculpture: Sculpture) {
        self.activeSculpture = sculpture
        clearPreview()
        
        let cameraAnchor = AnchorEntity(.camera)
        
        let sculptureEntity = buildSculptureEntity(from: sculpture, opacity: 0.5)
        let bounds = sculptureEntity.visualBounds(relativeTo: sculptureEntity)
        let size = bounds.extents
        let maxDimension = max(size.x, max(size.y, size.z))
        
        
        let targetSize: Float = 0.25
        let scaleFactor = maxDimension > 0 ? (targetSize / maxDimension) : 1.0
        
        let previewContainer = Entity()
        
        previewContainer.position = [0, -0.1, -2.0]
        
        previewContainer.scale = SIMD3<Float>(repeating: scaleFactor)
        
        sculptureEntity.position = -bounds.center
        
        previewContainer.addChild(sculptureEntity)
        cameraAnchor.addChild(previewContainer)
        
        arView.scene.addAnchor(cameraAnchor)
        self.previewAnchor = cameraAnchor
    }
    
    func anchorPreview() -> Bool {
        guard let sculpture = activeSculpture else { return false }
        let centerPoint = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        
        let results = arView.raycast(from: centerPoint, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = results.first {
            clearPreview()
            let anchorName = "sculpture_ID:\(sculpture.id.uuidString)"
            let arAnchor = ARAnchor(name: anchorName, transform: firstResult.worldTransform)
            arView.session.add(anchor: arAnchor)
            self.activeSculpture = nil
            
            self.saveWorldMap()
            
            return true
        }
        return false
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let name = anchor.name, name.hasPrefix("sculpture_ID:") else { continue }
            let uuidString = name.replacingOccurrences(of: "sculpture_ID:", with: "")
            guard let uuid = UUID(uuidString: uuidString) else { continue }
            
            let allSculptures = SwiftDataService.shared.fetchAll()
            guard let sculpture = allSculptures.first(where: { $0.id == uuid }) else { continue }
            
            let anchorEntity = AnchorEntity(anchor: anchor)
            let model = buildSculptureEntity(from: sculpture, opacity: 1.0)
            model.scale = [0.5, 0.5, 0.5]
            
            model.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation, .scale], for: model)
            
            anchorEntity.addChild(model)
            arView.scene.addAnchor(anchorEntity)
        }
    }
    
    func clearPreview() {
        if let existingAnchor = previewAnchor {
            arView.scene.removeAnchor(existingAnchor)
            previewAnchor = nil
        }
    }
    
    private func buildSculptureEntity(from sculpture: Sculpture, opacity: CGFloat) -> ModelEntity {
        let container = ModelEntity()
        container.name = sculpture.name
        let cubeSize: Float = 0.05
        guard let cubes = sculpture.cubes else { return container }
        for cube in cubes {
            let color = UIColor(red: CGFloat(cube.colorR), green: CGFloat(cube.colorG), blue: CGFloat(cube.colorB), alpha: opacity)
            let material = SimpleMaterial(color: color, isMetallic: false)
            let mesh = MeshResource.generateBox(size: cubeSize)
            let cubeEntity = ModelEntity(mesh: mesh, materials: [material])
            cubeEntity.position = SIMD3<Float>(cube.locationX, cube.locationY, cube.locationZ)
            container.addChild(cubeEntity)
        }
        return container
    }
}

// MARK: - Extensions
extension Entity {
    func findAnchorEntity() -> AnchorEntity? {
        if let anchor = self as? AnchorEntity { return anchor }
        return parent?.findAnchorEntity()
    }
    func findSculptureRoot() -> ModelEntity? {
        if self.parent is AnchorEntity { return self as? ModelEntity }
        return self.parent?.findSculptureRoot()
    }
}

extension AnchorEntity {
    var anchorIdentifier: UUID? {
        if case .anchor(let identifier) = self.anchoring.target { return identifier }
        return nil
    }
}

extension ARAnchor: Identifiable {}
