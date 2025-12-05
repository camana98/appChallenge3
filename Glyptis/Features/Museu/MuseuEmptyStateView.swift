import Foundation
import SwiftUI
internal import RealityKit

struct MuseuEmptyStateView: View {
    
    var onBackClicked: () -> Void
    
    @State private var isFloating = false
    @State private var showCanvas = false
    
    var body: some View {
        // MARK: - Troca de Tela
        if showCanvas {
            CanvasView(onCancel: {
                showCanvas = false
            })
            .transition(.opacity)
        } else {
            contentMuseu
                .transition(.opacity)
        }
    }
    
    // MARK: - Conteúdo do Museu
    var contentMuseu: some View {
        ZStack {
            
            // MARK: - Background
            Image(.backgroundMuseu)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 4)
            
            VStack {
                
                // MARK: - Header
                HStack {
                    SimpleCubeIcon(assetName: "backCube", width: 55, height: 55) {
                        onBackClicked()
                    }
                    
                    Spacer()
                    
                    Text("Museu")
                        .font(Fonts.title)
                        .foregroundStyle(.customWhite)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 55, height: 55)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Escultura e Coluna
                ZStack {
                    
                    /// Cubo
                    Image("newSculpture")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .padding(.bottom, 250)
                        .zIndex(1)
                        .offset(y: isFloating ? -5 : 5)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                            value: isFloating
                        )
                        .onTapGesture {
                             showCanvas = true
                        }
                    
                    Image("column")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 500)
                        .padding(.top, 200)
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding(.top, 50)
        }
        .onAppear {
            isFloating = true
        }
        .onDisappear {
            isFloating = false
        }
    }
}

#Preview {
    MuseuEmptyStateView(onBackClicked: {})
}
