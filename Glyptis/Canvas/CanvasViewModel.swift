//
//  CanvasViewModel.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 25/11/25.
//

import SwiftUI
import Combine
import SwiftData
import RealityKit

@MainActor
class CanvasViewModel: ObservableObject {
    @Published var removeMode: Bool = false
    @Published var selectedColor: Color = .green
    @Published var rotationY: Float = 0.0

    weak var coordinator: UnifiedCoordinator?

    func bindCoordinator(_ coordinator: UnifiedCoordinator) {
        self.coordinator = coordinator
        coordinator.removeMode = removeMode
        coordinator.selectedColor = UIColor(selectedColor)
        coordinator.updateRotation(rotationY)
    }

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
}


