//
//  MuseuButtonsComponent.swift
//  Glyptis
//
//  Created by Eduardo Camana on 08/12/25.
//

import Foundation
import SwiftUI
//import UIKit

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
                        // AQUI: Agora chama a função de abrir câmera limpa
                        onOpenCamera()
                    }
                    Text("Câmera AR")
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
//            .padding(.bottom, 22)
        }
        .padding(.top, 26)
        .padding(.horizontal, 24)
        .padding(.bottom, 54)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
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
                        // Aqui continua chamando o modo de ancoragem
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
