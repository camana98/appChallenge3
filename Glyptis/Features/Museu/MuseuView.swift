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
            
            VStack {
                HStack {
                    
                    SimpleCubeIcon(assetName: "backCube", width: 55, height: 55) {
                        onBackClicked()
                    }
                    
                    Spacer()
                    
                    Text("Museu")
                        .font(.custom("Angle Square DEMO", size: 24))
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                    
                    SimpleCubeIcon(assetName: "gridCube", width: 55, height: 55) {
                        showGridListMuseum.toggle()
                    }
                }
                .padding(.top)
                
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
//    MuseuView(vm: MuseuViewModel(), onBackClicked: {})
}
