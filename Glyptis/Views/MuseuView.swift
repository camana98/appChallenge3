//
//  MuseuView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 25/11/25.
//

import Foundation
import SwiftUI
import RealityKit

struct MuseuView: View {
    var body: some View {
        ZStack {
            
            Image(.backgroundMuseu)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    CubeButtonComponent(cubeStyle: .checkmark, cubeColor: .blue)
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                    
                    Spacer()
                    
                    Text("Museu")
                    
                    Spacer()
                    
                    CubeButtonComponent(cubeStyle: .checkmark, cubeColor: .blue)
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                }
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 32)
                        .foregroundStyle(.foregroundMuseu)
                        .opacity(0.9)
                    
                    HStack(spacing: 0) {
                        VStack(spacing: -4) {
                            CubeButtonComponent(cubeStyle: .demolish, cubeColor: .blue)
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                            Text("Deletar")
                        }
                        
                        VStack(spacing: -4) {
                            CubeButtonComponent(cubeStyle: .demolish, cubeColor: .blue)
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                            Text("Deletar")
                        }
                        
                        VStack(spacing: -4) {
                            CubeButtonComponent(cubeStyle: .demolish, cubeColor: .blue)
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                            Text("Deletar")
                        }
                        
                        VStack(spacing: -4) {
                            CubeButtonComponent(cubeStyle: .demolish, cubeColor: .blue)
                                .frame(width: 100, height: 100)
                                .scaledToFill()
                            Text("Deletar")
                        }
                        
                        
                    }
                }
                
            }
        }
    }
}

#Preview {
    MuseuView()
}
