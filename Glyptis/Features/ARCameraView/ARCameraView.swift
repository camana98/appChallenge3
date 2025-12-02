//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    
    var onOpenCanvas: () -> Void
    var onOpenMuseum: () -> Void
    
    var body: some View {
        ZStack {
            
            ARViewContainer(coordinator: $coordinator)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Button {
                    onOpenMuseum()
                } label: {
                    Text("Ir para Museu")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
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
    ARCameraView(onOpenCanvas: {}, onOpenMuseum: {})
}
