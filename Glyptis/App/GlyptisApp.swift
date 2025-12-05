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
    
    @State private var currentScreen: AppScreen = .camera
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
                        currentScreen = .camera
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
                    }
                )
            }
        }
        .modelContainer(service.modelContainer)
    }
}


