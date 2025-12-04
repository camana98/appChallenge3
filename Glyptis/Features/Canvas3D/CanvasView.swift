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
    @State private var arView: ARView?
    @State private var showSaveAlert = false
    @State private var showColorPicker: Bool = false
    @State private var showConfirmClear: Bool = false
    
    @State private var snapshot: Data? = nil
    
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: - Background & 3D
            Image("backgroundCanvas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture {
                    if showColorPicker {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showColorPicker = false
                        }
                    }
                }
            
            UnifiedCanvasContainer(
                removeMode: $vm.removeMode,
                selectedColor: $vm.selectedColor,
                rotationY: $vm.rotationY,
                usdzFileName: "canvasColumn",
                modelScale: 0.013,
                modelOffset: SIMD3<Float>(0, -3.9, 0),
                viewModel: vm,
                onARViewCreated: { view in
                    DispatchQueue.main.async {
                        self.arView = view
                    }
                }
            )
            
            // MARK: - Camada invisível para fechar picker
            if showColorPicker {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showColorPicker = false
                        }
                    }
                    .zIndex(1)
            }
            
            // MARK: - Top Buttons
            VStack {
                HStack {
                    SimpleCubeIcon(assetName: "cancelCube", width: 55, height: 56) {
                        onCancel()
                    }
                    .accessibilityIdentifier("CloseCanvasButton")
                    
                    Spacer()
                    
                    Text("Nova Escultura")
                        .font(.custom("Angle Square DEMO", size: 24))
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                    
                    SimpleCubeIcon(assetName: "saveCube", width: 55, height: 56) {
                        guard let arView else { return }
                        
                        let referenceModel = arView.scene.findEntity(named: "reference_model")
                        let gridLines = arView.scene.findEntity(named: "grid_lines")
                        
                        referenceModel?.isEnabled = false
                        gridLines?.isEnabled = false
                        
                        SnapshotService.takeSnapshot(from: arView) { image in
                            guard let image else { return }
                            
                            referenceModel?.isEnabled = true
                            gridLines?.isEnabled = true
                            
                            self.snapshot = image.pngData()
                            
                            showNamingPopup = true
                        }
                    }
                    .accessibilityIdentifier("SaveSculptureButton")
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                
                Spacer()
                
                footer()
            }
            .zIndex(2)
            .ignoresSafeArea(edges: .bottom)
            
            namingPopup()
        }
        
        // MARK: - Alerts
        .alert("Tem certeza que deseja limpar tudo?", isPresented: $showConfirmClear) {
            Button("Cancelar", role: .cancel) {}
            Button("Limpar", role: .destructive) {
                vm.clearAllCubes()
            }
            .accessibilityIdentifier("ConfirmClearButton")
        }
        .onChange(of: vm.selectedColor) { _ in
            vm.removeMode = false
        }
        
        .alert("heheeeee", isPresented: $showSaveAlert) {
            Button("OK") {}
        }
    }
    
    // MARK: - Footer (ferramentas ou color picker)
    private func footer() -> some View {
        VStack {
            if showColorPicker {
                ColorPickerComponent(
                    selectedColor: $vm.selectedColor,
                    onColorSelected: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showColorPicker = false
                        }
                    }
                )
                .padding(.top, 24)
                .padding(.bottom, 60)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .accessibilityIdentifier("ColorPickerComponent")
                
            } else {
                toolsButtonsView()
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                
                UnevenRoundedRectangle(topLeadingRadius: 35, topTrailingRadius: 35)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .white.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 35, topTrailingRadius: 35))
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
        )
    }
    
    
    // MARK: - Tools Buttons
    private func toolsButtonsView() -> some View {
        HStack(spacing: 60) {
            
            Button(action: { vm.toggleRemove() }) {
                VStack(spacing: 6) {
                    SimpleCubeIcon(
                        assetName: vm.removeMode ? "demolishCubeActive" : "demolishCube",
                        width: 54,
                        height: 56
                    ) {
                        vm.toggleRemove()
                    }
                    
                    Text("Demolir")
                        .font(.custom("NotoSans-Medium", size: 15))
                        .foregroundColor(vm.removeMode ? .customRed : .accent)
                }
            }
            .accessibilityIdentifier("DemolishCubeButton")
            
            Button(action: { showConfirmClear = true }) {
                VStack(spacing: 6) {
                    SimpleCubeIcon(
                        assetName: "clearAllCube",
                        width: 54,
                        height: 56
                    ) {
                        showConfirmClear = true
                    }
                    Text("Limpar")
                        .font(.custom("NotoSans-Medium", size: 15))
                        .foregroundColor(.accent)
                }
            }
            .accessibilityIdentifier("ClearAllButton")
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showColorPicker = true
                }
            } label: {
                VStack(spacing: 6) {
                    ZStack {
                        SimpleCubeIcon(
                            assetName: "changeColorCube",
                            width: 54,
                            height: 56
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showColorPicker = true
                            }
                        }
                        
                        Circle()
                            .fill(vm.selectedColor)
                            .stroke(Color.white, lineWidth: 1.5)
                            .frame(width: 20, height: 20)
                            .offset(x: 16, y: -16)
                    }
                    Text("Cor")
                        .font(.custom("NotoSans-Medium", size: 15))
                        .foregroundColor(.accent)
                }
            }
            .accessibilityIdentifier("ChangeColorButton")
        }
    }
    
    // MARK: - Naming Popup
    @ViewBuilder
    private func namingPopup() -> some View {
        if showNamingPopup {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { showNamingPopup = false }
            
            NameSculpturePopup(
                sculptureName: $sculptureName,
                onSave: {
                    guard !sculptureName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    guard !vm.unfinishedCubes.isEmpty else { return }
                    
                    showNamingPopup = false
                    
                    let service = SculptureService(context: context)
                    
                    guard let snapshot else { return }
                    let saved = service.create(
                        name: sculptureName,
                        author: nil,
                        localization: nil,
                        cubes: vm.unfinishedCubes,
                        snapshot: snapshot
                    )
                    
                    vm.currentSculpture = saved
                },
                onCancel: {
                    showNamingPopup = false
                }
            )
            .transition(.opacity)
            .zIndex(4)
        }
    }
}

#Preview {
    CanvasView() {
        print("voltei")
    }
}
