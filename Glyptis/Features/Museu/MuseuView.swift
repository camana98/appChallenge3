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
                    ForEach(vm.sculptures) { sculpture in
                        ZStack(alignment: .bottom) {
                            
                            VStack(spacing: 0) {
                                
                                Image(uiImage: vm.getSnapshot(s: sculpture))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 100, maxHeight: 100)
                                
                                Image(.colunaMuseu)
                                    .padding(.bottom, 50)
                                    .padding(.leading, 10)
                            }
                            
                            MuseuSculptureComponent( sculpture: sculpture)
                                .padding(.top, 325)
                            
                        }
                        
                    }
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
            vm.fetchData()
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
