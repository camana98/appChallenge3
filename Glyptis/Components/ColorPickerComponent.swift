//
//  ColorPickerComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import SwiftUI

struct ColorPickerComponent: View {
    @Binding var selectedColor: Color
    private let colors: [Color] = [.red, .blue, .yellow, .purple, .green]
    
    
    var body: some View {
        VStack {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .foregroundColor(color)
                    .frame(width: 50)
//                    .opacity(color == selectedColor ? 0.5 : 1.0)
//                    .border(color == selectedColor ? Color.black : Color.clear)
                    .scaleEffect(color == selectedColor ? 1.2 : 1.0)
                    .onTapGesture {
                        self.selectedColor = color
                    }
                
            }
        }
    }
}

#Preview {
    ColorPickerComponent(selectedColor: .constant(.blue))
}
