//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    @State var coordinator = ARViewCoordinator()
    @State private var showCanvas = false

    var body: some View {
        ZStack(alignment: .bottom) {
//            ARViewContainer(coordinator: $coordinator)
//                .edgesIgnoringSafeArea(.all)
            
            /// Desabilitado temporariamente, desenvolver na sprint 2

            Button {
                showCanvas = true
            } label: {
                Text("Ir para Canvas")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
        }
        .fullScreenCover(isPresented: $showCanvas) {
            CanvasView()
                .interactiveDismissDisabled(true)   // impede swipe pra voltar
        }
    }
}
