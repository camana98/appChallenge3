//
//  CanvasView.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 25/11/25.
//

import SwiftUI
import RealityKit

import SwiftUI

struct CanvasView: View {
    @StateObject private var vm = CanvasViewModel()

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
                    Spacer()

                    Button(action: {
                        vm.toggleRemove()
                    }) {
                        Text(vm.removeMode ? "Modo: REMOVER" : "Modo: ADICIONAR")
                            .font(.headline)
                            .padding()
                            .background(vm.removeMode ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                    
                    
                }

                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(colorOptions, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: vm.selectedColor == color ? 4 : 0)
                                )
                                .shadow(radius: 3)
                                .onTapGesture {
                                    vm.selectColor(color)
                                }
                        }
                    }
                    .padding()
                }
                .padding(.bottom, 30)
            }
        }
    }
}
