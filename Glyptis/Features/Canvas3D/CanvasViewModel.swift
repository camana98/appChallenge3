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
    @Published var cubes: [Cube] = []

    weak var coordinator: UnifiedCoordinator?
    
    // Escultura atual sendo construída
    var currentSculpture: Sculpture?

    func bindCoordinator(_ coordinator: UnifiedCoordinator) {
        self.coordinator = coordinator
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

    // MARK: - Cubos

    func addCube(_ unfinished: UnfinishedCube) {
        guard let sculpture = currentSculpture else { return }

        let cube = Cube(
            sculpture: sculpture,
            x: unfinished.locationX,
            y: unfinished.locationY,
            z: unfinished.locationZ,
            r: unfinished.colorR,
            g: unfinished.colorG,
            b: unfinished.colorB
        )

        cubes.append(cube)
        let key = "\(Int(cube.locationX))_\(Int(cube.locationZ))"
        coordinator?.addCube(atKey: key, fromBase: true)
    }

    func addCubeDirectly(x: Float, y: Float, z: Float) {
        guard let sculpture = currentSculpture else { return }
        let cube = Cube(
            sculpture: sculpture,
            x: x,
            y: y,
            z: z,
            r: Float(selectedColor.cgColor?.components?[0] ?? 0),
            g: Float(selectedColor.cgColor?.components?[1] ?? 1),
            b: Float(selectedColor.cgColor?.components?[2] ?? 0)
        )
        cubes.append(cube)
        let key = "\(Int(cube.locationX))_\(Int(cube.locationZ))"
        coordinator?.addCube(atKey: key, fromBase: true)
    }

    func removeCube(at cube: Cube) {
        guard let lastIndex = cubes.lastIndex(where: { $0.id == cube.id }) else { return }
        cubes.remove(at: lastIndex)
        let key = "\(Int(cube.locationX))_\(Int(cube.locationZ))"
        coordinator?.removeCube(in: key)
    }

    func clearAllCubes() {
        coordinator?.clearAllCubes()
        cubes.removeAll()
    }

    // Renderiza cubos da escultura atual
    func renderAllCubes() {
        for cube in cubes {
            let key = "\(Int(cube.locationX))_\(Int(cube.locationZ))"
            coordinator?.addCube(atKey: key)
        }
    }

    // MARK: - Criar escultura a partir de rascunhos
    func createSculpture(name: String, author: Author, unfinishedCubes: [UnfinishedCube]) {
        let sculpture = Sculpture(name: name, author: author)
        currentSculpture = sculpture

        for uCube in unfinishedCubes {
            addCube(uCube)
        }
    }
}
