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
                            Image("newMuseu")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 54, height: 56)
                            
                            Text("Museu")
                                .font(.custom("NotoSans-Medium", size: 15))
                                .fontWeight(.medium)
                                .foregroundStyle(.noite)
                        }
                        .frame(width: 89, height: 82)
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
                        .frame(width: 89, height: 82)
                    }
                }
                .padding(.top, 26)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 54)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
                                .preferredColorScheme(.light)
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
           isCameraAccessDenied = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    isCameraAccessDenied = !granted
                }
            }
        case .denied, .restricted:
            isCameraAccessDenied = true
        @unknown default:
            break
        }
    }
}

