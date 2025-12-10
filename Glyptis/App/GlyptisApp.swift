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
    case camera(sculpture: Sculpture? = nil)
    case canvas(sculpture: Sculpture? = nil)
    case museu
}

@main
struct GlyptisApp: App {
    
    // Monitora o estado do app (Ativo, Background, Fechado)
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var currentScreen: AppScreen = .museu
    let service = SwiftDataService.shared
    
    var body: some Scene {
        WindowGroup {
            switch currentScreen {
            case .camera(let sculpture):
                ARCameraView(
                    sculptureToAnchor: sculpture,
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
                        currentScreen = .camera(sculpture: nil)
                    },
                    onEditSculpture: { sculpture in
                        currentScreen = .canvas(sculpture: sculpture)
                    },
                    onAnchorSculpture: { sculpture in
                        currentScreen = .camera(sculpture: sculpture)
                    },
                    onOpenCamera: {
                        currentScreen = .camera(sculpture: nil)
                    },
                    onOpenCanvas: {
                        currentScreen = .canvas(sculpture: nil)
                    }
                )
            }
        }
        .modelContainer(service.modelContainer)
        // Ao mudar de estado (ex: minimizar app), salva o mapa AR
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                ARViewCoordinator.shared.saveWorldMap()
            }
        }
    }
}
