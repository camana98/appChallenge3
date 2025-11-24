//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    
    var body: some View {
        NavigationStack {
            ARViewContainer(coordinator: $coordinator)
                .edgesIgnoringSafeArea(.all)
            
            NavigationLink {
                ContentView()
            } label: {
                Text("Ir para Detalhes")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ARCameraView()
}
