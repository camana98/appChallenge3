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
    
    @State var vm: MuseuViewModelProtocol
    @State private var isFloating = false
    
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
                
                TabView {
//                                        ForEach(vm.sculptures) { sculpture in
                    ZStack(alignment: .bottom) {
                        
                        VStack(spacing: 0) {
                            
                            Image(.snapshot)
                            
//                                                            Image(uiImage: vm.getSnapshot(s: sculpture))
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 300, maxHeight: 300)
//                                .offset(y: 200)
                                .offset(y: isFloating ? 180 : 220) // deixa a diferença um pouco maior pra ficar visível
                                    .onAppear {
                                        withAnimation(
                                            .easeInOut(duration: 2.0)
                                                .repeatForever(autoreverses: true)
                                        ) {
                                            isFloating.toggle()
                                        }
                                    }
                                    .zIndex(1)
                            
                            Image(.colunaMuseu)

                                .padding(.leading, 10)
                        }
                        
//                                                    MuseuSculptureComponent( sculpture: sculpture)
                        MuseuSculptureComponent( sculpture: Sculpture(name: "Oiii"), vm: vm)
                            .padding(.bottom, 32)
                            .padding(.horizontal)
                    }
                    
//                                        }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
            }
            .padding(.top, 50)
        }
        
        
        .sheet(isPresented: $showGridListMuseum) {
            MuseuGridListView(vm: MuseuGridViewModel(service: SwiftDataService.shared))
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
        .onAppear {
            isFloating = true
            vm.fetchData()
        }
        .onDisappear {
            isFloating = false
        }
        
    }
}

#Preview {
    var previewVM = MuseuViewModel(service: SwiftDataService.shared)
    previewVM.sculptures = [
        Sculpture(name: "hahahahaha")
    ]
    
    return MuseuView(vm: previewVM) {
        print("zum")
    }
}
