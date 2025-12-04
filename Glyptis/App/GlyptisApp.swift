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
    let service = SwiftDataService.shared
    
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
                    vm: MuseuViewModel(service: service), onBackClicked: {
                        currentScreen = .camera
                    }
                )
            }
        }
        .modelContainer(service.modelContainer)
    }
}


