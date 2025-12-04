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
    case museu
}

@main
struct GlyptisApp: App {
    /// Estado que mantém a tela atual do app
    @State private var currentScreen: AppScreen = .camera
    @Environment(\.modelContext) private var context

    var body: some Scene {
        WindowGroup {
            switch currentScreen {
                /// Tela de câmera AR
            case .camera:
                ARCameraView(
                    onOpenCanvas: {
                        currentScreen = .canvas
                    },
                    onOpenMuseum: {
                        currentScreen = .museu
                    }
                )
            case .canvas:
                /// Tela de canvas 3D
                CanvasView(
                    onCancel: {
                        currentScreen = .camera
                    }
                )
            case .museu:
                /// Tela de museu
                MuseuView(
                    vm: MuseuViewModel(context: context, service: SculptureService(context: context)),
                    onBackClicked: {
                        currentScreen = .camera
                    }
                )
            }
        }
        .modelContainer(for: [
            Author.self,
            Cube.self,
            Localization.self,
            Sculpture.self,
        ])
    }
}
