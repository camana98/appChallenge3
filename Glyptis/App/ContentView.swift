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
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
