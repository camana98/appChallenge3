//
//  PixelArtARViewContainer.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI

struct PixelArtARViewContainer: View {
    let pixels: [[Color]]
    let gridSize: Int
    @Environment(\.dismiss) var dismiss
    @State private var scale: Float = 1.0
    
    var body: some View {
        ZStack {
            PixelArtARView(pixels: pixels, gridSize: gridSize, scale: $scale)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
                
                VStack(spacing: 15) {
                    // Instruções
                    VStack(spacing: 8) {
                        Text("Aponte a câmera para uma parede ou superfície")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        
                        Text("Toque na tela para posicionar o quadro")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                    }
                    
                    // Controles de escala
                    HStack(spacing: 20) {
                        Button(action: {
                            scale = max(0.5, scale - 0.2)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        
                        Text("Escala: \(String(format: "%.1f", scale))x")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                        
                        Button(action: {
                            scale = min(3.0, scale + 0.2)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

