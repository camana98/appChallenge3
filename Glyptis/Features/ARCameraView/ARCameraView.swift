//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    
    // controla a abertura da tela de snapshots
    @State private var showSnapshots = false
    
    // Closure para avisar quando abrir o Canvas
    var onOpenCanvas: () -> Void
    
    var body: some View {
        ZStack {
            // aqui vai ficar a ARView real, usando coordinator
            Color.gray.opacity(0.2) /// Placeholder da câmera
            
            VStack {
                Spacer()
                
                // BOTÃO 1 — Abrir Canvas
                Button {
                    onOpenCanvas()
                } label: {
                    Text("Ir para Canvas")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // BOTÃO 2 — Ver Snapshots Salvos
                Button {
                    showSnapshots = true
                } label: {
                    Text("Ver Snapshots")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 12)
                .padding(.bottom, 50)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        // Sheet para abrir a galeria de snapshots
        .sheet(isPresented: $showSnapshots) {
            SnapshotListView()
        }
    }
}

#Preview {
    ARCameraView(onOpenCanvas: {})
}

