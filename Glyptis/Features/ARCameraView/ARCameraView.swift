//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI
import SwiftData

struct ARCameraView: View {

    @Environment(\.modelContext) private var context
    
    @State var coordinator = ARViewCoordinator()
    @State private var showSnapshots = false

    var onOpenCanvas: () -> Void
    var onOpenMuseum: () -> Void
    
    var body: some View {
        ZStack {
            ///  AR View
            ARViewContainer(coordinator: $coordinator)
                .edgesIgnoringSafeArea(.all)
            
            /// Camada de Interface
            VStack {
                Spacer()
                
                /// Área dos Botões
                HStack(spacing: 60) {
                    
                    /// Botão Museu
                    Button {
                        onOpenMuseum()
                    } label: {
                        VStack(spacing: 5) {
                            Image("newMuseu")
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
                
                .background(.ultraThinMaterial.opacity(1))
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
                .preferredColorScheme(ColorScheme.light)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ARCameraView(onOpenCanvas: {}, onOpenMuseum: {})
}
