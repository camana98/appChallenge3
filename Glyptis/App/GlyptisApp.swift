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
    @State private var currentScreen: AppScreen = .camera

    var body: some Scene {
        WindowGroup {
            switch currentScreen {
            case .camera:
                ARCameraView(
                    onOpenCanvas: { currentScreen = .canvas },
                    onOpenMuseum: { currentScreen = .museu }
                )
            case .canvas:
                CanvasView(onCancel: { currentScreen = .camera })
            case .museu:
                MuseuView(onBackClicked: {
                    currentScreen = .camera
                })
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
