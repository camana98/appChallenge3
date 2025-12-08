//
//  MuseuButtonsComponent.swift
//  Glyptis
//
//  Created by Eduardo Camana on 08/12/25.
//

import Foundation
import SwiftUI

struct MuseuButtonsComponent: View {
    
    
    var body: some View {
        
        VStack(spacing: 18) {
            
            //MARK: Botões
            HStack(spacing: 32) {
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "cameraAR", width: 54, height: 56) {
                        //MARK: Acao navega pra tela de Camera
                    }
                    Text("Câmera AR")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "toolboxCube", width: 54, height: 56) {
                        //MARK: Acao chamando MuseuSculptureComponent
                    }
                    Text("Opções")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "newSculpture", width: 54, height: 56) {
                        //MARK: Acao navega pra tela de Canvas
                    }
                    
                    Text("Nova escultura")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
    
                
            }
//            .padding(.bottom, 22)
        }
        .padding(.top, 26)
        .padding(.horizontal, 24)
        .padding(.bottom, 54)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
    }
    
    
    
}

#Preview {
    MuseuButtonsComponent()
}
