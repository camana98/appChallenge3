//
//  ARMainNavigationControls.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 09/12/25.
//

import SwiftUI

struct ARMainNavigationControls: View {
    var onOpenMuseum: () -> Void
    var onOpenCanvas: () -> Void
    
    var body: some View {
        HStack(spacing: 60) {
            Button {
                onOpenMuseum()
            } label: {
                VStack(spacing: 5) {
                    Image("newMuseu")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 54, height: 56)
                    Text("Museu")
                        .font(.custom("NotoSans-Medium", size: 15))
                        .fontWeight(.medium)
                        .foregroundStyle(.noite)
                }
                .frame(width: 89, height: 82)
            }
            
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
                .frame(width: 89, height: 82)
            }
        }
        .padding(.top, 26)
        .padding(.horizontal, 24)
        .padding(.bottom, 54)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 70, style: .continuous))
        .preferredColorScheme(.light)
    }
}
