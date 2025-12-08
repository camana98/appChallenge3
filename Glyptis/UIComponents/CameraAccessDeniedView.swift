//
//  CameraAccessDeniedView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 08/12/25.
//

import Foundation
import SwiftUI

struct CameraAccessDeniedView: View {
    var body: some View {
        ZStack {
            Image("backgroundMuseu")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "video.slash.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white.opacity(0.9))
                
                Text("Câmera indisponível")
                    .font(.custom("NotoSans-Medium", size: 22))
                    .foregroundStyle(.white)
                
                Text("Habilite o acesso nos Ajustes para visualizar esculturas no mundo real.")
                    .font(.custom("NotoSans-Regular", size: 16))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                } label: {
                    Text("Abrir Ajustes")
                        .font(.custom("NotoSans-Medium", size: 14))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.top, 10)
                }
            }
            // Empurra o conteúdo para cima para não sobrepor a barra de navegação inferior
            .padding(.bottom, 120)
        }
    }
}
