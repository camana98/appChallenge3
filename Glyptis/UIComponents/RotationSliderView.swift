//
//  RotationSliderView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 09/12/25.
//

import SwiftUI

struct RotationSliderView: View {
    @Binding var currentRotation: Float // Em graus (0...360)
    var onRotationChange: (Float) -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                
                Text("Girar")
                    .font(.custom("NotoSans-Bold", size: 14))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(Int(currentRotation))°")
                    .font(.custom("NotoSans-Medium", size: 14))
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, 4)
            
            HStack {
                Text("0°")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
                
                Slider(value: $currentRotation, in: 0...360)
                    .tint(Color.customGreen) // Use sua cor preferida (ex: customBlue ou customGreen)
                    .onChange(of: currentRotation) { newValue in
                        // Converte graus para radianos para o ARKit
                        let radians = newValue * (.pi / 180)
                        onRotationChange(radians)
                    }
                
                Text("360°")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 4)
        .padding(.horizontal, 24)
    }
}
