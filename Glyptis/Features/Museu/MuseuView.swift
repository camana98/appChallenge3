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
    
    @Query private var sculptures: [Sculpture]
    
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
                
                if sculptures.isEmpty {
                    MuseuEmptyStateView(onBackClicked: onBackClicked)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(vm.sculptures) { sculpture in
                                ZStack(alignment: .bottom) {
                                    VStack(spacing: 0) {
                                        
                                        Image(uiImage: vm.getSnapshot(s: sculpture))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: 100, maxHeight: 100)
                                        
                                        Image(.colunaMuseu)
                                            .resizable()
                                            .padding(.bottom, 50)
                                            .padding(.leading, 10)
                                    }
                                    .scrollTransition { content, phase in //  editar coisas quando não estão no centro
                                        content
                                            .blur(radius: phase.isIdentity ? 0 : 1)
                                            .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                            .brightness(phase.isIdentity ? 0 : -0.35)
                                            .offset(y: phase.isIdentity ? 0 : -90) // vai pra cima qunaod não esá
                                    }
                                    
                                    MuseuSculptureComponent(sculpture: sculpture)
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1.0 : 0.0)
                                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                                .offset(y: phase.isIdentity ? 0 : -90)
                                        }
                                    
                                }
                                .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 0)
                                .frame(width: UIScreen.main.bounds.width * 0.7) // frame da escultura e do pilar
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned) // permite o efeito de imã
                    .safeAreaPadding(.horizontal, (UIScreen.main.bounds.width * 0.15))  // area pra cada um dos lados
                    
                }
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

