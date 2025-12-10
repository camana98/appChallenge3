//
//  HeightSliderView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 09/12/25.
//

import SwiftUI

struct HeightSliderView: View {
    @Binding var currentHeight: Float
    var onHeightChange: (Float) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "arrow.up")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .shadow(radius: 2)
            
            // Slider Vertical (Fino e Alto)
            Slider(value: $currentHeight, in: -1.0...1.0)
                .tint(Color.blue)
                .frame(width: 300) // Define COMPRIMENTO
                .rotationEffect(.degrees(-90))
                .frame(width: 30, height: 300) // Define ESPAÇO NA TELA
                .fixedSize()
                .onChange(of: currentHeight) { newValue in
                    onHeightChange(newValue)
                }
            
            Image(systemName: "arrow.down")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .shadow(radius: 2)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(radius: 6)
    }
}
