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
    case canvas(sculpture: Sculpture? = nil)
    case museu
}

@main
struct GlyptisApp: App {
    
    @State private var currentScreen: AppScreen = .museu
    let service = SwiftDataService.shared
    
    var body: some Scene {
        WindowGroup {
            switch currentScreen {
            case .camera:
                ARCameraView(
                    onOpenCanvas: { currentScreen = .canvas(sculpture: nil) },
                    onOpenMuseum: { currentScreen = .museu }
                )
            case .canvas(let sculpture):
                /// Tela de canvas 3D
                CanvasView(
                    sculptureToEdit: sculpture,
                    onCancel: {
                        currentScreen = .museu
                    },
                    onSave: {
                        currentScreen = .museu
                    }
                )
            case .museu:
                /// Tela de museu
                MuseuView(
                    vm: MuseuViewModel(service: service),
                    onBackClicked: {
                        currentScreen = .camera
                    },
                    onEditSculpture: { sculpture in
                        currentScreen = .canvas(sculpture: sculpture)
                    },
                    onOpenCamera: {
                        currentScreen = .camera
                    },
                    onOpenCanvas: {
                        currentScreen = .canvas(sculpture: nil)
                    }
                )
            }
        }
        .modelContainer(service.modelContainer)
    }
}


