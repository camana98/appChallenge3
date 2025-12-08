//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI
import SwiftData
import AVFoundation

struct ARCameraView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) var scenePhase
    
    @State var coordinator = ARViewCoordinator()
    @State private var isCameraAccessDenied = false

    var onOpenCanvas: () -> Void
    var onOpenMuseum: () -> Void
    
    var body: some View {
        ZStack {
            
            /// 1. Camada da Câmera
            ARViewContainer(coordinator: $coordinator)
                .edgesIgnoringSafeArea(.all)
                .opacity(isCameraAccessDenied ? 0 : 1)
            
            /// 2. Camada de Aviso com IMAGEM DE FUNDO (Meio)
            if isCameraAccessDenied {
                CameraAccessDeniedView()
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            /// 3. Camada de Interface dos Botões
            VStack {
                Spacer()
                
                HStack(spacing: 60) {
                    
                    /// Botão Museu
                    Button {
                        onOpenMuseum()
                    } label: {
                        VStack(spacing: 5) {
                            Image("museum")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 54, height: 54)
                            
                            Text("Museu")
                                .font(.custom("NotoSans-Medium", size: 15))
                                .fontWeight(.medium)
                                .foregroundStyle(.noite)
                        }
                    }
                    
                    /// Botão Canvas
                    Button {
                        onOpenCanvas()
                    } label: {
                        VStack(spacing: 5) {
                            Image("newSculpture")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 54, height: 54)
                            
                            Text("Canvas")
                                .font(.custom("NotoSans-Medium", size: 15))
                                .fontWeight(.medium)
                                .foregroundStyle(.noite)
                        }
                    }
                }
                .padding(.top, 26)
                .padding(.bottom, 26)
                .frame(maxWidth: .infinity)
                .background {
                    ZStack {
                        Color.white.opacity(0.5)
                        Rectangle()
                            .fill(Material.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                    }
                }
                .clipShape(
                    .rect(
                        topLeadingRadius: 35,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 35
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                .overlay(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 35, bottomLeading: 0, bottomTrailing: 0, topTrailing: 35))
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
            .edgesIgnoringSafeArea(.bottom)
            .zIndex(2)
        }
        .onAppear {
            checkCameraPermission()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                checkCameraPermission()
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            withAnimation { isCameraAccessDenied = false }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    withAnimation { isCameraAccessDenied = !granted }
                }
            }
        case .denied, .restricted:
            withAnimation { isCameraAccessDenied = true }
        @unknown default:
            break
        }
    }
}

