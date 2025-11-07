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
    
    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<gridSize, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<gridSize, id: \.self) { col in
                        PixelView(
                            color: pixels[row][col],
                            size: pixelSize
                        )
                        .onTapGesture {
                            onPixelTapped(row, col)
                        }
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.2))
        .padding()
    }
}

