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
    
//    private var sculptures: [Sculpture]
    
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
                    
                    ForEach(vm.fetchData()) { sculpture in
                        
                        
                        VStack(spacing: 0) {
                            
                            Image(uiImage: vm.getSnapshot(s: sculpture))
                            
                            Image(.colunaMuseu)
                                .padding(.bottom, 50)
                                .padding(.leading, 10)
                        }
                        
                        MuseuSculptureComponent( sculpture: sculpture)
                            .padding(.top, 325)
                        
                    }
                }
                
                
            }
            .padding(.top, 50)
        }
        .sheet(isPresented: $showGridListMuseum) {
            MuseuGridListView(vm: MuseuGridViewModel(context: modelContext, service: SculptureService(context: modelContext)))
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
        .task {
            vm.fetchData()
        }
    }
}

#Preview {
    @Environment(\.modelContext) var modelContext
    
    MuseuView(vm: MuseuViewModel(context: modelContext, service: SculptureService(context: modelContext)), onBackClicked: {})
}
