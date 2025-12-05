//
//  MuseuSculptureComponent.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 26/11/25.
//

import Foundation
import SwiftUI

struct MuseuSculptureComponent: View {
    
    var sculpture: Sculpture
    @State var vm: MuseuViewModelProtocol
    
    var body: some View {
        
        VStack(spacing: 18) {
            
            VStack(spacing: 8) {
                //MARK: Nome da Escultura
                Text(sculpture.name)
                    .font(Fonts.title)
                    .foregroundStyle(.customNight)
                
                //MARK: Data de Criacao
                Text("Criado em \(sculpture.formattedCreatedAt)")
                    .font(Fonts.notoRegular)
                    .foregroundStyle(.customNight)
            }
            
            //MARK: Botões
            HStack {
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "deleteCube", width: 54, height: 56) {
                        vm.delete(s: sculpture)
                    }
                    Text("Deletar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customRed)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "editCube", width: 54, height: 56) {
                        vm.edit(s: sculpture)
                    }
                    Text("Editar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "pinCube", width: 54, height: 56) {
                        vm.anchor(s: sculpture)
                    }
                    
                    Text("Ancorar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "emptyHeartCube", width: 54, height: 56) {
//                        vm.favorite(s: sculpture)
                    }
                    
                    Text("Favoritar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
            }
//            .padding(.bottom, 22)
        }
        .padding(.top, 18)
        .padding(.horizontal, 24)
        .padding(.bottom, 54)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
    }
    
    
    
}

#Preview {
//    MuseuSculptureComponent(sculpture: Sculpture(name: "Test", localization: nil, author: nil), vm: MuseuViewModel()) arrumar se quiser usar
}
