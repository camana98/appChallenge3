//
//  ColorPickerComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import SwiftUI

struct ColorPickerComponent: View {
    @State var selectedHexID: Int?
    @Binding var selectedColor: Color
    
    var beehiveSize: CGFloat = 16
    
    // Linhas principais
    private var hiveLines: [[HexColor]] {
        [
            ColorPalete.line1,
            ColorPalete.line2,
            ColorPalete.line3,
            ColorPalete.line4,
            ColorPalete.line5,
            ColorPalete.line6,
            ColorPalete.line7,
            ColorPalete.line8,
            ColorPalete.line9,
            ColorPalete.line10,
            ColorPalete.line11,
            ColorPalete.line12,
            ColorPalete.line13
        ]
    }
    
    var body: some View {
        let horizontalOverlap = beehiveSize * (0.866 - 1)
        let verticalOverlap   = beehiveSize * 0.25   // 0.75 da altura entre centros
        
        VStack(spacing: 24) {
            Text("Alterar cor")
                .font(.largeTitle)
            
            // Favo principal
            VStack(spacing: -verticalOverlap) {
                ForEach(hiveLines.indices, id: \.self) { rowIndex in
                    HStack(spacing: horizontalOverlap) {
                        ForEach(hiveLines[rowIndex]) { hexColor in
                            hexagonView(for: hexColor)
                        }
                    }
                }
            }
            
            // Escala de cinza + hex de preview
            HStack(spacing: 24) {
                VStack(spacing: -verticalOverlap) {
                    HStack(spacing: horizontalOverlap) {
                        ForEach(ColorPalete.line14) { hexColor in
                            hexagonView(for: hexColor)
                        }
                    }
                    HStack(spacing: horizontalOverlap) {
                        ForEach(ColorPalete.line15) { hexColor in
                            hexagonView(for: hexColor)
                        }
                    }
                }
                
                RootHexagon()
                    .fill(selectedColor)
                    .stroke(Color.black.opacity(0.15), lineWidth: 2)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(24)
        .frame(width: 320, height: 360)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
    
    // MARK: - Subview
    
    @ViewBuilder
    private func hexagonView(for hexColor: HexColor) -> some View {
        let isSelected = selectedHexID == hexColor.id
        
        Hexagon(
            id: hexColor.id,
            isSelected: isSelected,
            hexagonColor: hexColor.color
        ) {
            selectedColor = hexColor.color
            selectedHexID = hexColor.id
        }
        .frame(width: beehiveSize, height: beehiveSize)
        .zIndex(isSelected ? 1 : 0)   // garante que a borda do selecionado fique por cima
    }
}

#Preview {
    ColorPickerComponent(selectedHexID: 3, selectedColor: .constant(.red))
}
