//
//  ARPlacementControls.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 09/12/25.
//

import SwiftUI

struct ARPlacementControls: View {
    var onCancel: () -> Void
    var onConfirm: () -> Void
    
    var body: some View {
        HStack(spacing: 60) {
            /// Botão Cancelar
            VStack(spacing: 5) {
                SimpleCubeIcon(
                    assetName: "cancelCube",
                    width: 56,
                    height: 56,
                    action: onCancel
                )
                Text("Cancelar")
                    .font(.custom("NotoSans-Medium", size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(.noite)
            }
            .frame(width: 89, height: 82)
            
            /// Botão Fixar
            VStack(spacing: 5) {
                SimpleCubeIcon(
                    assetName: "saveCube",
                    width: 56,
                    height: 56,
                    action: onConfirm
                )
                Text("Fixar")
                    .font(.custom("NotoSans-Medium", size: 15))
                    .fontWeight(.medium)
                    .foregroundStyle(.noite)
            }
            .frame(width: 89, height: 82)
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
