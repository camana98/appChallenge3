//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    
    // Closure para avisar quando abrir o Canvas
    var onOpenCanvas: () -> Void
    
    var body: some View {
        ZStack {
            // aqui vai ficar a ARView real, usando coordinator
            Color.gray.opacity(0.2) /// Placeholder da câmera
            
            VStack {
                Spacer()
                
                Button {
                    onOpenCanvas()
                } label: {
                    Text("Ir para Canvas")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ARCameraView(onOpenCanvas: {})
}
