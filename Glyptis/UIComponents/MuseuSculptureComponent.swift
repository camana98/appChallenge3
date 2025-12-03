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
    
    var body: some View {
        
        VStack(spacing: 16) {
            
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
                VStack(alignment: .center, spacing: -8) {
                    CubeButtonComponent(cubeStyle: .trash, cubeColor: .red){
                        
                    }
                    .frame(width: 89, height: 82)
                    Text("Deletar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customRed)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: -8) {
                    CubeButtonComponent(cubeStyle: .pencil, cubeColor: .blue){
                        
                    }
                    .frame(width: 89, height: 82)
                    Text("Editar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: -8) {
                    CubeButtonComponent(cubeStyle: .map, cubeColor: .blue){
                        
                    }
                    .frame(width: 89, height: 82)
                    Text("Ancorar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                VStack(alignment: .center, spacing: -8) {
                    CubeButtonComponent(cubeStyle: .heart, cubeColor: .blue){
                        
                    }
                    .frame(width: 89, height: 82)
                    Text("Favoritar")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
            }
            .padding(.bottom, 22)
        }
        .padding(.top, 20)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
                   
    }
    
    
    
}

#Preview {
    MuseuSculptureComponent(sculpture: Sculpture(name: "Test", localization: nil, author: nil))
}
