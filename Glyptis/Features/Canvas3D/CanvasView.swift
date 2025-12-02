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
    
    // Estados de UI
    @State private var showNamingPopup: Bool = false
    @State private var sculptureName: String = ""
    @State private var showColorPicker: Bool = false
    @State private var showConfirmClear: Bool = false
    
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // MARK: Layer 1 - Background & 3D Content
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
                viewModel: vm
            )
            
            /// Camada invisível para detectar cliques fora da área do menu (fecha o picker)
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
            
            // MARK: Layer 2 - UI Fixa
            VStack(spacing: 0) {
                /// Topo
                HStack {
                    CubeButtonComponent(
                        cubeStyle: .xmark,
                        cubeColor: .red
                    ) {
                        onCancel()
                    }
                    .frame(width: 100, height: 100)
                    
                    Spacer()
                    
                    CubeButtonComponent(
                        cubeStyle: .checkmark,
                        cubeColor: .green
                    ) {
                        showNamingPopup = true
                    }
                    .frame(width: 100, height: 100)
                }
                .padding(.top, 60)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Rodapé
                VStack {
                    if showColorPicker {
                        /// MODO: SELETOR DE COR
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
                        Rectangle()
                            .fill(.ultraThinMaterial)
                        
                        UnevenRoundedRectangle(topLeadingRadius: 35, topTrailingRadius: 35)
                            .stroke(LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            ), lineWidth: 1)
                    }
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 35, topTrailingRadius: 35))
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
                )
            }
            .ignoresSafeArea(edges: .bottom)
            .zIndex(2)
            
            // MARK: Layer 3 - Outros Popups
            namingPopup()
        }
        .alert("Tem certeza que deseja limpar tudo?", isPresented: $showConfirmClear) {
            Button("Cancelar", role: .cancel) {}
            Button("Limpar", role: .destructive) {
                vm.clearAllCubes()
            }
        }
        .onChange(of: vm.selectedColor) { _ in
            vm.removeMode = false
        }
    }
    
    // MARK: - Subviews
    
    private func toolsButtonsView() -> some View {
        HStack(spacing: 60) {
            // 1. Botão Demolir
            Button(action: { vm.toggleRemove() }) {
                VStack(spacing: 6) {
                    SimpleCubeIcon(
                        assetName: vm.removeMode ? "demolishCubeActive" : "demolishCube",
                        action: { vm.toggleRemove() },
                        width: 44,
                        height: 46
                    )
                    Text("Demolir")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
            }
            
            // 2. Botão Limpar
            Button(action: { showConfirmClear = true }) {
                VStack(spacing: 6) {
                    SimpleCubeIcon(
                        assetName: "clearAllCube",
                        action: { showConfirmClear = true },
                        width: 44,
                        height: 46
                    )
                    Text("Limpar")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
            }
            
            // 3. Botão Cor
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showColorPicker = true
                }
            }) {
                VStack(spacing: 6) {
                    ZStack {
                        SimpleCubeIcon(
                            assetName: "changeColorCube",
                            action: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showColorPicker = true
                                }
                            },
                            width: 44,
                            height: 46
                        )
                        
                        Circle()
                            .fill(vm.selectedColor)
                            .stroke(Color.white, lineWidth: 1.5)
                            .frame(width: 12, height: 12)
                            .offset(x: 16, y: -16)
                    }
                    
                    Text("Cor")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
            }
        }
    }
    
    @ViewBuilder
    private func namingPopup() -> some View {
        if showNamingPopup {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { showNamingPopup = false }
            
            NameSculpturePopup(
                sculptureName: $sculptureName,
                onSave: { showNamingPopup = false },
                onCancel: { showNamingPopup = false }
            )
            .transition(.opacity)
            .zIndex(3)
        }
    }
}
