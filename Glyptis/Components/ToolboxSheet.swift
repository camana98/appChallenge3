//
//  ToolboxSheet.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI

struct ToolboxSheet: View {
    var onDemolish: () -> Void
    var onCleanAll: () -> Void
    var onChangeColor: () -> Void
    @Binding var isVisible: Bool
    @Binding var isDemolishActive: Bool
    @State private var showConfirmClear: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isVisible = false
                    }
                }
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    /// Título do menu
                    Text("Ferramentas")
                        .font(.headline)
                        .bold()
                        .padding(.top, 16)
                        .foregroundColor(.black)
                    
                    /// Botões
                    HStack(spacing: 50) {
                        VStack {
                            SimpleCubeIcon(
                                assetName: isDemolishActive ? "demolishCubeActive" : "demolishCube",
                                action: onDemolish,
                                width: 54,
                                height: 56
                            )
                            
                            Text("Demolir")
                                .font(.system(size: 15))
                                .foregroundColor(Color("customBlue"))
                                .padding(.bottom, 50)
                        }
                       
                        
                        VStack {
                            SimpleCubeIcon(
                                assetName: "clearAllCube",
                                action: { showConfirmClear = true },
                                width: 54,
                                height: 56
                            )
                            
                            Text("Limpar")
                                .font(.system(size: 15))
                                .foregroundColor(Color("customBlue"))
                                .padding(.bottom, 50)
                        }
                        .alert("Tem certeza que deseja limpar tudo?", isPresented: $showConfirmClear) {
                            Button("Cancelar", role: .cancel) {}
                            Button("Limpar", role: .destructive) {
                                onCleanAll()
                                isVisible = false
                            }
                        }
                        
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 16)
                    
                }
                .background(.ultraThinMaterial.opacity(0.8))
                .cornerRadius(16)
                .offset(y: isVisible ? 0 : 300)
                .animation(.easeInOut(duration: 0.35), value: isVisible) 
            }
        }

    }
}

