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
    
    @State var vm: MuseuViewModelProtocol
    
    @State private var showGridListMuseum: Bool = false
    var onBackClicked: () -> Void
    
    var body: some View {
        ZStack {
            
            Image(.backgroundMuseu)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 9.0)
            
            VStack {
                HStack {
                    
                    SimpleCubeIcon(assetName: "backCube", width: 55, height: 55) {
                        onBackClicked()
                    }
                    
                    Spacer()
                    
                    Text("Museu")
                        .font(Fonts.title)
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                    
                    SimpleCubeIcon(assetName: "gridCube", width: 55, height: 55) {
                        showGridListMuseum.toggle()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                ZStack {
                    
                    VStack(spacing: 0) {
                        
                        //TODO: colocar snapshot aqui e ajustar tamanho, tem que fazer a logica de qual snapshot é de qual escultura
                        
                        Image(.colunaMuseu)
                            .padding(.bottom, 50)
                            .padding(.leading, 10)
                    }
                        
                    MuseuSculptureComponent( sculpture: Sculpture(name: "Test", localization: nil, author: nil))
                        .padding(.top, 325)
                }
                
                
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
//    MuseuView(vm: MuseuViewModel(), onBackClicked: {})
}
