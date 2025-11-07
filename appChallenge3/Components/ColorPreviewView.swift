//
//  ColorPreviewView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI

struct ColorPreviewView: View {
    let selectedColor: Color
    
    var body: some View {
        HStack {
            Text("Cor Selecionada:")
                .font(.headline)
            RoundedRectangle(cornerRadius: 8)
                .fill(selectedColor)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
        .padding(.vertical, 8)
    }
}

