//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI
import SwiftData
import AVFoundation
import ARKit

struct ARCameraView: View {
    
    let coordinator = ARViewCoordinator.shared
    
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isCameraAccessDenied = false
    @State var sculptureToAnchor: Sculpture?
    @State private var showAdjustmentHint: Bool = false
    @State private var anchorToDelete: ARAnchor? = nil
    @State private var showEditControls: Bool = false
    @State private var currentHeight: Float = 0.0
    @State private var currentRotation: Float = 0.0
    @State private var showHelpPopup: Bool = false
    @State private var showPlacementError: Bool = false

    var onOpenCanvas: () -> Void
    var onOpenMuseum: () -> Void
    
    var body: some View {
        ZStack {
            
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
                .opacity(isCameraAccessDenied ? 0 : 1)
            
            if showPlacementError {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                        
                        Text("Não foi possível fixar.\nProcure uma superfície plana e bem iluminada.")
                            .font(.callout)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 60)
                    
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(10)
            }
            
            if isCameraAccessDenied {
                CameraAccessDeniedView()
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            if showHelpPopup {
                CameraHelpPopup(isPresented: $showHelpPopup)
                    .zIndex(5)
                    .transition(.opacity)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Text("Camera")
                        .font(Fonts.title)
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                Spacer()
                
                if showEditControls && sculptureToAnchor == nil {
                    RotationSliderView(
                        currentRotation: $currentRotation,
                        onRotationChange: { radians in
                            coordinator.updateRotation(to: radians)
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                } else if let _ = sculptureToAnchor {
                    ARPlacementControls(
                        onCancel: {
                            coordinator.clearPreview()
                            withAnimation { sculptureToAnchor = nil }
                            showPlacementError = false
                        },
                        onConfirm: {
                            let success = coordinator.anchorPreview()
                            
                            if success {
                                /// SUCESSO
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                                withAnimation {
                                    sculptureToAnchor = nil
                                    showAdjustmentHint = true
                                    showPlacementError = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    withAnimation { showAdjustmentHint = false }
                                }
                            } else {
                                /// FALHA - Mostra o erro
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.error)
                                
                                withAnimation {
                                    showPlacementError = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    withAnimation {
                                        showPlacementError = false
                                    }
                                }
                            }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    ARMainNavigationControls(
                        onOpenMuseum: onOpenMuseum,
                        onOpenInfo: {
                            withAnimation { showHelpPopup = true }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.top, -100)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .zIndex(2)
            
            
            if showEditControls && sculptureToAnchor == nil {
                HStack {
                    Spacer()
                    HeightSliderView(
                        currentHeight: $currentHeight,
                        onHeightChange: { newValue in
                            coordinator.updateHeight(to: newValue)
                        }
                    )
                }
                .padding(.trailing, 24)
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .zIndex(3)
            }
        }
        .onAppear {
            checkCameraPermission()
            setupCoordinatorCallbacks()
            
            if let sculpture = sculptureToAnchor {
                coordinator.showPreview(of: sculpture)
            } else {
                coordinator.clearPreview()
            }
        }
        .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        checkCameraPermission()
                    } else if newPhase == .background || newPhase == .inactive {
                        // MARK: - Salvar mapa ao sair do app
                        print("💾 App indo para background, salvando WorldMap...")
                        coordinator.saveWorldMap()
                    }
                }
        .alert(item: $anchorToDelete) { anchor in
            Alert(
                title: Text("Remover escultura?"),
                message: Text("Tem certeza que deseja remover esta escultura?"),
                primaryButton: .destructive(Text("Remover")) {
                    coordinator.remove(anchor: anchor)
                    SoundManager.shared.playSound(named: "removeCube", volume: 1)
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
    
    func setupCoordinatorCallbacks() {
        coordinator.onAnchorLongPressed = { anchor in
            if sculptureToAnchor == nil {
                self.anchorToDelete = anchor
            }
        }
        
        coordinator.onEntitySelected = { height, rotationRadians in
            if sculptureToAnchor == nil {
                withAnimation {
                    self.currentHeight = height
                    self.currentRotation = rotationRadians * (180 / .pi)
                    if self.currentRotation < 0 { self.currentRotation += 360 }
                    
                    self.showEditControls = true
                }
            }
        }
        
        coordinator.onSelectionCleared = {
            withAnimation {
                self.showEditControls = false
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: isCameraAccessDenied = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { isCameraAccessDenied = !granted }
            }
        case .denied, .restricted: isCameraAccessDenied = true
        @unknown default: break
        }
    }
}
