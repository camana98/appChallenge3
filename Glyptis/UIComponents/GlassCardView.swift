//
//  ArrowComponent.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 05/12/25.
//

import SwiftUI

struct GlassCardView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Inaugure seu Museu")
                .font(.custom("Angle Square DEMO", size: 24))
                .foregroundStyle(.noite)
            
            Text("Toque no cubo no topo do pedestal para criar sua primeira escultura.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(.noite)
                .padding(.horizontal, 20)
        }
        .padding(.top, 30)
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
        .frame(maxWidth: .infinity)
        .background(
            Material.ultraThinMaterial
        )
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
    }
}

#Preview {
    ZStack {
        Image("backgroundMuseu")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            GlassCardView()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}
