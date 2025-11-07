//
//  ActionButtonsView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI

struct ActionButtonsView: View {
    let onSave: () -> Void
    let onShowArtworks: () -> Void
    let onClear: () -> Void
    let onShowAR: () -> Void
    let onToggleEraser: () -> Void
    let isEraserMode: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: onSave) {
                    VStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.down")
                            .font(.title3)
                        Text("Salvar")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: onShowArtworks) {
                    VStack(spacing: 4) {
                        Image(systemName: "list.bullet")
                            .font(.title3)
                        Text("Meus")
                            .font(.caption)
                        Text("Desenhos")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: onClear) {
                    VStack(spacing: 4) {
                        Image(systemName: "trash")
                            .font(.title3)
                        Text("Limpar")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            HStack(spacing: 12) {
                Button(action: onToggleEraser) {
                    VStack(spacing: 4) {
                        Image(systemName: isEraserMode ? "eraser.fill" : "eraser")
                            .font(.title3)
                        Text("Borracha")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isEraserMode ? Color.orange : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: onShowAR) {
                    HStack {
                        Image(systemName: "arkit")
                            .font(.title3)
                        Text("Ver em AR")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 30)
    }
}

