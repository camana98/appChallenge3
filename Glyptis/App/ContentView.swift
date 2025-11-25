//
//  ContentView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 19/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedColor: Color = .yellow
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(selectedColor)
            Text("Hello, world!")
        }
        
        VStack {
            ColorPickerComponent(selectedColor: $selectedColor)
            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundColor(selectedColor)
            Text("\(selectedColor.description)")
                .font(.system(size: 30))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
