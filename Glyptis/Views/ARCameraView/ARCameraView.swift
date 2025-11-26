//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    @State private var goToCanvas = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Button {
                    goToCanvas = true
                } label: {
                    Text("Ir para Canvas")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationDestination(isPresented: $goToCanvas) {
                CanvasView()
                    .navigationBarBackButtonHidden(true)    
                    .navigationBarHidden(true)
  
            }
        }
    }
}

#Preview {
    ARCameraView()
}
