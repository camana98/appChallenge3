//
//  CanvasView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI
internal import RealityKit

struct CanvasView: View {
    @StateObject private var vm = CanvasViewModel()
    @State private var showNamingPopup: Bool = false
    @State private var sculptureName: String = ""
    @State private var showToolbox: Bool = false
    @State private var arView: ARView?
    @State private var showSaveAlert = false


    var showColors: Bool = false
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: Background
            Image("backgroundCanvas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // MARK: Canvas
            UnifiedCanvasContainer(
                removeMode: $vm.removeMode,
                selectedColor: $vm.selectedColor,
                rotationY: $vm.rotationY,
                usdzFileName: "canvasColumn",
                modelScale: 0.013,
                modelOffset: SIMD3<Float>(0, -3.9, 0),
                viewModel: vm,
                onARViewCreated: { view in
                    arView = view
                }
            )
            
            // Top Buttons
            HStack {
                CubeButtonComponent(
                    cubeStyle: .xmark,
                    cubeColor: .red
                ) {
                    onCancel()
                }
                .frame(width: 140, height: 140)
                
                Spacer()
                CubeButtonComponent(
                    cubeStyle: .checkmark,
                    cubeColor: .green
                ) {
                    guard let arView else { return }

                    SnapshotService.takeSnapshot(from: arView) { image in
                        guard let image = image else { return }

                        SnapshotService.saveSnapshot(image) { _ in
                            // Nada acontece na UI — apenas salva.
                        }
                    }

                    showNamingPopup = true
                }
                .frame(width: 140, height: 140)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 75)
            
            
            
            // Bottom Buttons
            if !showToolbox {
                HStack {
                    CubeButtonComponent(
                        cubeStyle: .toolbox,
                        cubeColor: .blue
                    ) {
                        showToolbox = true
                    }
                    .frame(width: 140, height: 140)

                    
                    Spacer()
                    CubeButtonComponent(
                        cubeStyle: .addCube,
                        cubeColor: .blue
                    ) {
                        // ação de adicionar cubo
                    }
                    .frame(width: 140, height: 140)

                }
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 50)
            }
            
            // MARK: Popups
            namingPopup()
            toolboxSheet()
        }
        
        .alert("heheeeee", isPresented: $showSaveAlert) {
            Button("OK") {}
        }
    }
    
    // MARK: - Popups
    
    @ViewBuilder
    private func namingPopup() -> some View {
        if showNamingPopup {
            NameSculpturePopup(
                sculptureName: $sculptureName,
                onSave: {
                    showNamingPopup = false
                    
                },
                onCancel: { showNamingPopup = false }
            )
            .transition(.opacity)
            .zIndex(1)
        }
    }
    
    @ViewBuilder
    private func toolboxSheet() -> some View {
        if showToolbox {
            ToolboxSheet(
                onDemolish: { vm.toggleRemove() },
                onCleanAll: { vm.clearAllCubes() },
                onChangeColor: { }, // * implementar color picker
                isVisible: $showToolbox,
                isDemolishActive: $vm.removeMode
            )
            .zIndex(1)
        }
    }
    
    func save3DPreview() {

    }
}
