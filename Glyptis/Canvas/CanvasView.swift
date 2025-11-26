//
//  CanvasView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 25/11/25.
//

import SwiftUI
import RealityKit

struct CanvasView: View {
    @StateObject private var vm = CanvasViewModel()
    var showColors = false
    
    private let colorOptions: [Color] = [
        .red, .green, .blue, .yellow, .orange, .purple,
        .cyan, .brown, .white, .black
    ]

    var body: some View {
        ZStack {
            Image("backgroundCanvas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            UnifiedCanvasContainer(
                removeMode: $vm.removeMode,
                selectedColor: $vm.selectedColor,
                rotationY: $vm.rotationY,
                usdzFileName: "canvasColumn",
                modelScale: 0.013,
                modelOffset: SIMD3<Float>(0, -3.9, 0),
                viewModel: vm
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    CubeButtonComponent(cubeStyle: .xmark, cubeColor: .red) {
                        print("Cubo vermelho clicado")
                    }
                    .frame(width: 80, height: 80)

                    Spacer()

                    CubeButtonComponent(cubeStyle: .checkmark, cubeColor: .green) {
                        print("Cubo verde clicado")
                    }
                    .frame(width: 80, height: 80)
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)

                Spacer()
                
                HStack {
                    CubeButtonComponent(cubeStyle: .toolbox, cubeColor: .red) {}
                    .frame(width: 80, height: 80)

                    CubeButtonComponent(cubeStyle: .rollback, cubeColor: .green) {}
                    .frame(width: 80, height: 80)
                    
                    CubeButtonComponent(cubeStyle: .rollfront, cubeColor: .green) {}
                    .frame(width: 80, height: 80)
                    
                    CubeButtonComponent(cubeStyle: .demolish, cubeColor: .green) {}
                    .frame(width: 80, height: 80)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)

//                HStack {
//                    Spacer()
//                    Button(action: {
//                        vm.toggleRemove()
//                    }) {
//                        Text(vm.removeMode ? "Modo: REMOVER" : "Modo: ADICIONAR")
//                            .font(.headline)
//                            .padding()
//                            .background(vm.removeMode ? Color.red : Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(12)
//                            .shadow(radius: 5)
//                    }
//                    .padding(.trailing, 20)
//                }
//                
//               
//                    // Paleta de cores
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(colorOptions, id: \.self) { color in
//                                Circle()
//                                    .fill(color)
//                                    .frame(width: 50, height: 50)
//                                    .overlay(
//                                        Circle()
//                                            .stroke(Color.white, lineWidth: vm.selectedColor == color ? 4 : 0)
//                                    )
//                                    .shadow(radius: 3)
//                                    .onTapGesture {
//                                        vm.selectColor(color)
//                                    }
//                            }
//                        }
//                        .padding()
//                    }
            }
        }
    }
}
