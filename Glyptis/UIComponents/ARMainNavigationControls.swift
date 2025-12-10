//
//  ARMainNavigationControls.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 09/12/25.
//

import SwiftUI

struct ARMainNavigationControls: View {
    
    var onOpenMuseum: () -> Void
    var onOpenInfo: () -> Void
    
    private let topCornerRadius: CGFloat = 50
    
    var body: some View {
        VStack(spacing: 18) {
            
            // MARK: Botões
            HStack(spacing: 60) {
                
                // Botão Museu
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "newMuseu", width: 54, height: 56) {
                        onOpenMuseum()
                    }
                    
                    Text("Museu")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
                
                // Botão Ajuda
                VStack(alignment: .center, spacing: 4) {
                    SimpleCubeIcon(assetName: "infoCube", width: 62, height: 64) {
                        onOpenInfo()
                    }
                    
                    Text("Ajuda")
                        .font(Fonts.notoCubeButton)
                        .foregroundStyle(.customBlue)
                }
                .frame(width: 89, height: 82)
            }
        }
        .padding(.top, 28)
        .padding(.bottom, 35)
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: topCornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: topCornerRadius
            )
        )
        .overlay(
            UnevenRoundedRectangle(
                topLeadingRadius: topCornerRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: topCornerRadius
            )
            .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        .ignoresSafeArea(edges: .bottom) 
        .preferredColorScheme(.light)
    }
}
