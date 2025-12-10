//
//  CanvasViewModel.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI
import Combine
internal import RealityKit

@MainActor
class CanvasViewModel: ObservableObject {
    @Published var removeMode: Bool = false
    @Published var selectedColor: Color = .customBlue
    @Published var rotationY: Float = 0.0
//    @Published var cubes: [Cube] = [] NAO VAI SER MAIS USADO, VAMOS USAR UNFINISHED
    @Published var unfinishedCubes: [UnfinishedCube] = []

    weak var coordinator: UnifiedCoordinator?

    // Escultura atual sendo construída
    var currentSculpture: Sculpture?

    func bindCoordinator(_ coordinator: UnifiedCoordinator) {
        self.coordinator = coordinator
        coordinator.delegate = self
        coordinator.removeMode = removeMode
        coordinator.selectedColor = UIColor(selectedColor)
        coordinator.updateRotation(rotationY)
        renderAllCubes()
    }

    // Alterna entre modo remover/adicionar
    func toggleRemove() {
        removeMode.toggle()
        coordinator?.removeMode = removeMode
    }

    func selectColor(_ color: Color) {
        selectedColor = color
        removeMode = false
        coordinator?.selectedColor = UIColor(color)
    }

    func updateRotation(_ value: Float) {
        rotationY = value
        coordinator?.updateRotation(value)
    }

    func clearAllCubes() {
        coordinator?.clearAllCubes()
        unfinishedCubes.removeAll()
    }

    // Renderiza cubos da escultura atual
    // Renderiza cubos da escultura atual
        func renderAllCubes() {
            guard let coordinator = coordinator else { return }
            
            // Dados necessários para o cálculo correto do índice
            let stride = coordinator.cubeSize + coordinator.gap
            let offset = coordinator.baseOffset
            
            for cube in unfinishedCubes {
                // CORREÇÃO: Converter posição do mundo (Float) para índice da grade (Int)
                let xIndex = Int(round((cube.locationX + offset) / stride))
                let zIndex = Int(round((cube.locationZ + offset) / stride))
                
                let key = "\(xIndex)_\(zIndex)"
                
                let color = UIColor(
                    red: CGFloat(cube.colorR),
                    green: CGFloat(cube.colorG),
                    blue: CGFloat(cube.colorB),
                    alpha: CGFloat(cube.colorA)
                )
                let position = SIMD3<Float>(cube.locationX, cube.locationY, cube.locationZ)

                coordinator.addCube(at: position, key: key, color: color, skipHeightUpdate: true, animated: false)
            }
        }
    
    // MARK: - Carregar escultura existente para edição
    func loadSculpture(_ sculpture: Sculpture) {
        currentSculpture = sculpture
        
        // Limpa os cubos atuais
        unfinishedCubes.removeAll()
        coordinator?.clearAllCubes()
        
        // Converte os Cubes da escultura para UnfinishedCubes
        guard let cubes = sculpture.cubes else { return }
        
        for cube in cubes {
            let unfinished = UnfinishedCube(
                locationX: cube.locationX,
                locationY: cube.locationY,
                locationZ: cube.locationZ,
                colorR: cube.colorR,
                colorG: cube.colorG,
                colorB: cube.colorB,
                colorA: cube.colorA ?? 1.0
            )
            unfinishedCubes.append(unfinished)
        }
        
        // Renderiza todos os cubos carregados
        renderAllCubes()
    }

    // MARK: - Criar escultura a partir de rascunhos
    func createSculpture(name: String, author: Author, unfinishedCubes: [UnfinishedCube]) {
        let sculpture = Sculpture(name: name, author: author)
        currentSculpture = sculpture

//        for uCube in unfinishedCubes {
//            //addCube(uCube)
//        }
    }
}

extension CanvasViewModel: CubeDelegate {
    func didAddCube(x: Float, y: Float, z: Float, colorR: Float, colorG: Float, colorB: Float, colorA: Float) {
        let unfinished = UnfinishedCube(
            locationX: x,
            locationY: y,
            locationZ: z,
            colorR: colorR,
            colorG: colorG,
            colorB: colorB,
            colorA: colorA
        )
        unfinishedCubes.append(unfinished)
    }
    
    func didRemoveCube(x: Float, y: Float, z: Float) {
        // Remove o cubo do array usando posição (x, y, z)
        // Usa uma tolerância pequena para comparação de floats
        if let index = unfinishedCubes.firstIndex(where: { 
            abs($0.locationX - x) < 0.01 && 
            abs($0.locationY - y) < 0.01 &&
            abs($0.locationZ - z) < 0.01
        }) {
            unfinishedCubes.remove(at: index)
        }
    }
}
