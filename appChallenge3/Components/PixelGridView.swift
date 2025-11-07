//
//  PixelGridView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI

struct PixelGridView: View {
    let pixels: [[Color]]
    let gridSize: Int
    let pixelSize: CGFloat
    let onPixelTapped: (Int, Int) -> Void
    
    @State private var lastTouchedPixel: (row: Int, col: Int)? = nil
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<gridSize, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<gridSize, id: \.self) { col in
                        PixelView(
                            color: pixels[row][col],
                            size: pixelSize
                        )
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.2))
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary.opacity(0.3), lineWidth: 2)
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let location = value.location
                    let pixelRow = getPixelRow(from: location)
                    let pixelCol = getPixelCol(from: location)
                    
                    if pixelRow >= 0 && pixelRow < gridSize && 
                       pixelCol >= 0 && pixelCol < gridSize {
                        let currentPixel = (row: pixelRow, col: pixelCol)
                        
                        // Evita chamar o mesmo pixel múltiplas vezes durante o arrasto
                        if lastTouchedPixel?.row != currentPixel.row || lastTouchedPixel?.col != currentPixel.col {
                            lastTouchedPixel = currentPixel
                            onPixelTapped(pixelRow, pixelCol)
                        }
                    }
                }
                .onEnded { _ in
                    lastTouchedPixel = nil
                }
        )
    }
    
    private func getPixelRow(from location: CGPoint) -> Int {
        // Ajusta para o padding (16) e calcula a linha
        let adjustedY = location.y - 16
        let row = Int(adjustedY / (pixelSize + 1))
        return max(0, min(row, gridSize - 1))
    }
    
    private func getPixelCol(from location: CGPoint) -> Int {
        // Ajusta para o padding (16) e calcula a coluna
        let adjustedX = location.x - 16
        let col = Int(adjustedX / (pixelSize + 1))
        return max(0, min(col, gridSize - 1))
    }
}

