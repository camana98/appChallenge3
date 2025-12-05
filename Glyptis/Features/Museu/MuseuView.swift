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
    @State private var selectedSculptureID: Sculpture.ID?
    
    @State private var showGridListMuseum: Bool = false
    var onBackClicked: () -> Void
    var onEditSculpture: ((Sculpture) -> Void)?
    
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
                
                if vm.sculptures.isEmpty {
                    MuseuEmptyStateView(onBackClicked: onBackClicked)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(vm.sculptures) { sculpture in
                                ZStack(alignment: .bottom) {
                                    VStack(spacing: 0) {
                                        
                                        FloatingSculptureImage(
                                            image: vm.getSnapshot(s: sculpture),
                                            isActive: selectedSculptureID == sculpture.id
                                        )
                                        
                                        Image(.colunaMuseu)
//                                            .resizable()
//                                            .padding(.bottom, 50)
                                            .padding(.leading, 10)
                                    }
                                    .scrollTransition { content, phase in //  editar coisas quando não estão no centro
                                        content
                                            .blur(radius: phase.isIdentity ? 0 : 1)
                                            .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                            .brightness(phase.isIdentity ? 0 : -0.35)
                                            .offset(y: phase.isIdentity ? 0 : -90) // vai pra cima qunaod não esá
                                    }
                                    
                                    MuseuSculptureComponent(sculpture: sculpture, vm: vm)
                                        .padding(.bottom, 42)
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
                    .scrollPosition(id: $selectedSculptureID)
                    .safeAreaPadding(.horizontal, (UIScreen.main.bounds.width * 0.15))  // area pra cada um dos lados
                    
                    //                                        }
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
            if let onEdit = onEditSculpture {
                vm.setOnEditNavigation(onEdit)
            }
        }
        
    }
}

private struct FloatingSculptureImage: View {
    let image: UIImage
    let isActive: Bool
    
    @State private var offsetY: CGFloat = 220
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: 300, maxHeight: 300)
            .offset(y: offsetY)
            .zIndex(1)
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    startFloating()
                } else {
                    stopFloating()
                }
            }
            .onAppear {
                if isActive {
                    startFloating()
                }
            }
    }
    
    private func startFloating() {
        withAnimation(
            .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            offsetY = 180
        }
    }
    
    private func stopFloating() {
        withAnimation(.easeOut(duration: 0.3)) {
            offsetY = 220
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
