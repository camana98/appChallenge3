//
//  ColorPickerComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import SwiftUI

struct ColorPickerComponent: View {
    @State private var selectedColor: Color = .blue
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            ColorPicker("Color Picker", selection: $selectedColor)
        }
    }
}

#Preview {
    ColorPickerComponent()
}
