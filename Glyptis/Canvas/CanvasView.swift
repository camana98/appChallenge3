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
    @Environment(\.modelContext) private var context
    
    @State private var showNamingPopup: Bool = false
    @State private var sculptureName: String = ""
    @State private var showToolbox: Bool = false
    
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
                viewModel: vm
            )
            
            // Top Buttons
            HStack {
                SimpleCubeIcon(assetName: "cancelCube", action: { onCancel() }, width: 54, height: 56)
                Spacer()
                SimpleCubeIcon(assetName: "saveCube", action: {
                    showNamingPopup = true
                }, width: 54, height: 56)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 75)
            
            // Bottom Buttons
            if !showToolbox {
                HStack {
                    SimpleCubeIcon(assetName: "toolboxCube", action: { showToolbox = true }, width: 54, height: 140)
                    Spacer()
                    SimpleCubeIcon(assetName: "addCube", action: { /* ?? */ }, width: 54, height: 56)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 50)
            }
            
            // MARK: Popups
            namingPopup()
            toolboxSheet()
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
                    

                    // MARK: 1) Converter para UnfinishedCube
                    let unfinished = vm.cubes.map { cube in
                        UnfinishedCube(
                            locationX: cube.locationX,
                            locationY: cube.locationY,
                            locationZ: cube.locationZ,
                            colorR: cube.colorR,
                            colorG: cube.colorG,
                            colorB: cube.colorB,
                            colorA: cube.colorA ?? 1
                        )
                    }

//                    vm.createSculpture(name: sculptureName, author: nil, unfinishedCubes: unfinished)
                    
                    // MARK: 2) Criar service
                    let service = SculptureService(context: context)

                    // MARK: 3) Salvar escultura e cubos no SwiftData
                    let saved = service.create(
                        name: sculptureName,
                        author: nil,
                        localization: nil,
                        cubes: unfinished
                    )

                    print("ESCULTURA SALVA → \(saved.name)")
                    vm.currentSculpture = saved
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
}
