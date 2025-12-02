//
//  MuseuView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 25/11/25.
//

import Foundation
import SwiftUI
internal import RealityKit
import SwiftData

struct MuseuView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var showGridListMuseum: Bool = false
    var onBackClicked: () -> Void
    
    var body: some View {
        ZStack {
            
            Image(.backgroundMuseu)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    CubeButtonComponent(cubeStyle: .back, cubeColor: .blue) {
                        onBackClicked()
                    }
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                    
                    Spacer()
                    
                    Text("Museu")
                    
                    Spacer()
                    
                    CubeButtonComponent(cubeStyle: .grid, cubeColor: .blue) {
                        showGridListMuseum.toggle()
                    }
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                }
                
                Spacer()
                                
            }
        }
        .sheet(isPresented: $showGridListMuseum) {
            MuseuGridListView(vm: MuseuGridViewModel(context: modelContext, service: SculptureService(context: modelContext)))
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
    }
}

#Preview {
    MuseuView(onBackClicked: {})
}
