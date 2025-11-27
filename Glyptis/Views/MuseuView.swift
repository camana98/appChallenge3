//
//  MuseuView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 25/11/25.
//

import Foundation
import SwiftUI
import RealityKit

struct MuseuView: View {
    
    @State private var showGridListMuseum: Bool = false
    
    var body: some View {
        ZStack {
            
            Image(.backgroundMuseu)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 9.0)
            
            VStack {
                HStack {
                    CubeButtonComponent(cubeStyle: .back, cubeColor: .blue) {
                        
                    }
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                    
                    Spacer()
                    
                    Text("Museu")
                        .font(Fonts.title)
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                    
                    CubeButtonComponent(cubeStyle: .grid, cubeColor: .blue) {
                        showGridListMuseum.toggle()
                    }
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                }
                .padding(.horizontal)
                
                Spacer()
                
                ZStack {
                    Image(.colunaMuseu)
                        .padding(.bottom, 50)
                        .padding(.leading, 10)
                        
                    MuseuSculptureComponent( sculpture: Sculpture(name: "Test", localization: nil, author: nil))
                        .padding(.top, 325)
                }
                
                
            }
        }
        .sheet(isPresented: $showGridListMuseum) {
            MuseuGridListView()
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
    }
}

#Preview {
    MuseuView()
}
