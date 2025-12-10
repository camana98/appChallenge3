//
//  MuseuButtonsComponent.swift
//  Glyptis
//
//  Created by Eduardo Camana on 08/12/25.
//

import Foundation
import SwiftUI

struct MuseuButtonsComponent: View {
    
    var sculpture: Sculpture
    @State var vm: MuseuViewModelProtocol
    @Binding var sculptureToDelete: Sculpture?
    var onOpenCamera: () -> Void
    var onOpenCanvas: () -> Void
    var onAnchorSculpture: ((Sculpture) -> Void)?
    var onShowComingSoon: () -> Void
    
    @State private var showOptionsModal: Bool = false
    
    var body: some View {
        
        VStack(spacing: 18) {
            
            //MARK: Botões
            HStack(spacing: 32) {
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "cameraAR", width: 54, height: 56) {
                        onOpenCamera()
                    }
                    Text("Câmera")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "toolboxCube", width: 54, height: 56) {
                        showOptionsModal = true
                    }
                    Text("Opções")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "newSculpture", width: 54, height: 56) {
                        onOpenCanvas()
                    }
                    
                    Text("Nova escultura")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 108, height: 82)
            }
        }
        .padding(.top, 26)
        .padding(.horizontal, 24)
        .padding(.bottom, 54) // Padding interno para o conteúdo não colar na borda inferior
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial) // Efeito de vidro
        .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5) // Sombra suave
        .overlay( // Borda fina branca para efeito "Liquid"
            RoundedRectangle(cornerRadius: 70, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .preferredColorScheme(.light)
        .sheet(isPresented: $showOptionsModal) {
            MuseuSculptureComponent(
                sculpture: sculpture,
                vm: vm,
                onDeleteRequested: {
                    showOptionsModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        sculptureToDelete = sculpture
                    }
                },
                onAnchorRequested: {
                    showOptionsModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onAnchorSculpture?(sculpture)
                    }
                },
                onShowComingSoon: {
                    showOptionsModal = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onShowComingSoon()
                    }
                }
            )
            .padding(.top, 40)
            .presentationDetents([.height(188)])
            .frame(maxWidth: .infinity)
            .presentationDragIndicator(.visible)
            .presentationBackground(.clear)
            .preferredColorScheme(.light)
        }
    }
}
