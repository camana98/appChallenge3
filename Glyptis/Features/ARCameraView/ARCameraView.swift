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
    
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) var scenePhase
    
    let coordinator = ARViewCoordinator.shared
    
    @State private var isCameraAccessDenied = false
    @State var sculptureToAnchor: Sculpture?
    
    @State private var showAdjustmentHint: Bool = false
    @State private var anchorToDelete: ARAnchor? = nil
    
    // Controles de Edição
    @State private var showEditControls: Bool = false
    @State private var currentHeight: Float = 0.0
    @State private var currentRotation: Float = 0.0
    
    @State private var showHelpPopup: Bool = false

    var onOpenCanvas: () -> Void
    var onOpenMuseum: () -> Void
    
    var body: some View {
        ZStack {
            
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
                .opacity(isCameraAccessDenied ? 0 : 1)
            
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
                // --- TOPO ---
                HStack(alignment: .top) {
                    Spacer()
                    Button {
                        withAnimation { showHelpPopup = true }
                    } label: {
                        Image("infoCube")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54, height: 56)
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                Spacer()
                
                if showEditControls && sculptureToAnchor == nil {
                    RotationSliderView(
                        currentRotation: $currentRotation,
                        onRotationChange: { radians in
                            coordinator.updateRotation(to: radians)
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 40)
                    
                } else if let _ = sculptureToAnchor {
                    ARPlacementControls(
                        onCancel: {
                            coordinator.clearPreview()
                            withAnimation { sculptureToAnchor = nil }
                        },
                        onConfirm: {
                            let success = coordinator.anchorPreview()
                            if success {
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                                withAnimation {
                                    sculptureToAnchor = nil
                                    showAdjustmentHint = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                                    withAnimation { showAdjustmentHint = false }
                                }
                            }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    ARMainNavigationControls(
                        onOpenMuseum: onOpenMuseum,
                        onOpenCanvas: onOpenCanvas
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
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
