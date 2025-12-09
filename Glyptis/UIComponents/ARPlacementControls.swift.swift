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
        HStack(spacing: 40) {
            Button {
                onCancel()
            } label: {
                VStack(spacing: 5) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 56, height: 56)
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Text("Cancelar")
                        .font(.custom("NotoSans-Medium", size: 14))
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                }
            }
            
            Button {
                onConfirm()
            } label: {
                VStack(spacing: 5) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 70, height: 70)
                        Image(systemName: "checkmark")
                            .font(.system(size: 30, weight: .black))
                            .foregroundStyle(.white)
                    }
                    Text("Fixar")
                        .font(.custom("NotoSans-Bold", size: 16))
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                }
            }
            .offset(y: -20)
        }
        .padding(.bottom, 40)
    }
}
