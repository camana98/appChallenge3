//
//  CanvasView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI
internal import RealityKit
internal import ARKit

struct CanvasView: View {
    @StateObject private var vm = CanvasViewModel()
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showNamingPopup: Bool = false
    @State private var sculptureName: String = ""
    @State private var arView: ARView?
    @State private var showSaveAlert = false
    @State private var showColorPicker: Bool = false
    @State private var showConfirmClear: Bool = false
    @State private var snapshot: Data? = nil
    
    // NOVO: Estado para controlar se estamos na visão aérea ou não
    @State private var isAerialView: Bool = false
    
    var sculptureToEdit: Sculpture?
    
    var onCancel: () -> Void
    var onSave: (() -> Void)? = nil
    
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
                        
                        // Carrega a escultura após o ARView estar pronto
                        // Isso garante que o coordinator esteja inicializado
                        if let sculpture = sculptureToEdit {
                            vm.loadSculpture(sculpture)
                        }
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
                    
                    Text(sculptureToEdit != nil ? "Editar Escultura" : "Nova Escultura")
                        .font(.custom("Angle Square DEMO", size: 24))
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                    
                    SimpleCubeIcon(assetName: "saveCube", width: 55, height: 56) {
                        guard let arView else { return }
                        
                        // Atualiza a posição da câmera antes de tirar a snapshot
                        vm.coordinator?.updateCameraPosition(animated: true)
                        // Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {_ in
                            
                        // }
                        // guard let arView else { return }
                        
                        let referenceModel = arView.scene.findEntity(named: "reference_model")
                        let gridLines = arView.scene.findEntity(named: "grid_lines")
                        
                        referenceModel?.isEnabled = false
                        gridLines?.isEnabled = false
                        
                        // Aguarda um pouco para garantir que a câmera foi atualizada e tudo foi renderizado
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            SnapshotService.takeSnapshot(from: arView, cameraCoordinator: vm.coordinator) { image in
                                guard let image else {
                                    // Restaura os elementos mesmo em caso de erro
                                    referenceModel?.isEnabled = true
                                    gridLines?.isEnabled = true
                                    return
                                }
                                
                                // Restaura os elementos após a snapshot
                                referenceModel?.isEnabled = true
                                gridLines?.isEnabled = true
                                
                                self.snapshot = image.pngData()
                                
                                showNamingPopup = true
                            }
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
        .onAppear {
            // Define o nome da escultura se estiver editando
            if let sculpture = sculptureToEdit {
                sculptureName = sculpture.name
                // A escultura será carregada quando o ARView estiver pronto (no onARViewCreated)
            }
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
                    .environment(\.colorScheme, .light)
            }
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 35, topTrailingRadius: 35))
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
        )
    }
    
    
    // MARK: - Tools Buttons
    private func toolsButtonsView() -> some View {
        HStack(spacing: 30) {
            
            // 1. Demolir
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
                        .font(.custom("NotoSans-Medium", size: 12))
                        .foregroundColor(vm.removeMode ? .customRed : .accent)
                }
            }
            .accessibilityIdentifier("DemolishCubeButton")
            
            // 2. Limpar
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
                        .font(.custom("NotoSans-Medium", size: 12))
                        .foregroundColor(.accent)
                }
            }
            .accessibilityIdentifier("ClearAllButton")
            
            // 3. Visão Aérea / Normal (TOGGLE)
            Button {
                isAerialView.toggle()
                vm.coordinator?.toggleAerialView()
            } label: {
                VStack(spacing: 6) {
                    SimpleCubeIcon(
                        assetName: isAerialView ? "cameraAR" : "gridCube",
                        width: 54,
                        height: 56
                    ) {
                        isAerialView.toggle()
                        vm.coordinator?.toggleAerialView()
                    }
                    // Alterna o texto
                    Text(isAerialView ? "Visão 3D" : "Visão Aérea")
                        .font(.custom("NotoSans-Medium", size: 12))
                        .foregroundColor(.accent)
                }
            }
            
            // 4. Cor
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
                        .font(.custom("NotoSans-Medium", size: 12))
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
                    
                    let service = SculptureService(context: modelContext)
                    
                    guard let snapshot else { return }
                    
                    // Se estiver editando uma escultura existente, atualiza ela
                    if let existingSculpture = sculptureToEdit {
                        service.updateName(existingSculpture, to: sculptureName)
                        service.updateCubes(for: existingSculpture, with: vm.unfinishedCubes)
                        existingSculpture.snapshot = snapshot
                        vm.currentSculpture = existingSculpture
                    } else {
                        // Caso contrário, cria uma nova escultura
                        let saved = service.create(
                            name: sculptureName,
                            author: nil,
                            localization: nil,
                            cubes: vm.unfinishedCubes,
                            snapshot: snapshot
                        )
                        vm.currentSculpture = saved
                    }
                    
                    SoundManager.shared.playSound(named: "saveSuccess", volume: 0.5)
                    
                    // Navega para o museu após salvar
                    onSave?()
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
