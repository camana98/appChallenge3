//
//  GlyptisApp.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 19/11/25.
//
//  Estrutura principal do app Glyptis.

import SwiftUI
import SwiftData

/// Enum que define as telas principais do app
enum AppScreen {
    case camera
    case canvas
}

@main
struct GlyptisApp: App {
    /// Estado que mantém a tela atual do app
    @State private var currentScreen: AppScreen = .camera

    var body: some Scene {
        WindowGroup {
            switch currentScreen {
                /// Tela de câmera AR
            case .camera:
                ARCameraView(
                    onOpenCanvas: {
                        currentScreen = .canvas
                    }
                )
            case .canvas:
                /// Tela de canvas 3D
                CanvasView(
                    onCancel: {
                        currentScreen = .camera
                    },
                   
                )
            }
        }
        /// Define os modelos persistentes do SwiftData
        .modelContainer(for: [
            Author.self,
            Cube.self,
            Localization.self,
            Sculpture.self,
        ])
    }
}
