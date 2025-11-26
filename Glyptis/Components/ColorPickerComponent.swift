//
//  ColorPickerComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import SwiftUI

struct ColorPickerComponent: View {
    @Binding var selectedColor: Color
    
    @State var isSelected: Bool
    
    var beehiveSize: CGFloat = 16
    private let colorsLine1: [Color] = [.red, .blue, .yellow, .purple, .green, .orange, .black]
    private let colorsLine2: [Color] = [.blue, .yellow, .purple, .green, .orange, .black, .purple, .brown]
    
    
    
    var body: some View {
        let overlap = beehiveSize * (0.866-1)
        
       ScrollView {
           VStack(spacing: 0){
                HStack(spacing: overlap) {
                    ForEach(colorsLine1, id: \.self) { color in
                        Hexagon(isSelected: $isSelected)
                            .foregroundColor(color)
                            .frame(width: beehiveSize, height: beehiveSize)
                            .onTapGesture {
                                    self.isSelected = true
                                    self.selectedColor = color
                            }
                    }
                }
                HStack(spacing: overlap) {
                    ForEach(colorsLine2, id: \.self) { color in
                        Hexagon(isSelected: $isSelected)
                            .foregroundColor(color)
                            .frame(width: beehiveSize, height: beehiveSize)
                            .onTapGesture {
                                    self.selectedColor = color
                            }
                    }
                }
                .offset(y: -5) // line (1) * 5
               HStack(spacing: overlap) {
                   ForEach(colorsLine1, id: \.self) { color in
                       Hexagon(isSelected: $isSelected)
                           .foregroundColor(color)
                           .frame(width: beehiveSize, height: beehiveSize)
                           .onTapGesture {
                                   self.selectedColor = color
                           }
                   }
               }
               .offset(y: -10) // line (2) * 5
               
               HStack(spacing: overlap) {
                   ForEach(colorsLine2, id: \.self) { color in
                       Hexagon(isSelected: $isSelected)
                           .foregroundColor(color)
                           .frame(width: beehiveSize, height: beehiveSize)
                           .onTapGesture {
                                   self.selectedColor = color
                           }
                   }
               }
               .offset(y: -15) // line (1) * 5
            }
        }
        .frame(height: beehiveSize * 4) // * line num

    }
}

#Preview {
//    ColorPickerComponent(selectedColor: .constant(.blue), isSelected: .constant(true))
}

