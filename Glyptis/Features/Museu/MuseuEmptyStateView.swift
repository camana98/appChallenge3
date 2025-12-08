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
            
            // MARK: LAYER 1 - Escultura e Coluna
            VStack {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    
                    /// Coluna (Base)
                    Image("column")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 500)
                        .padding(.top, 50)
                    
                    /// Cubo (Flutuando)
                    Image("newSculpture")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .padding(.bottom, 450)
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
                }
            }
            
            // MARK: LAYER 2 - Interface
            VStack {
                Spacer()
                
                GlassCardView()
                    .environment(\.colorScheme, .light)
            }
        }
        .onAppear {
            isFloating = true
        }
        .onDisappear {
            isFloating = false
        }
    }
}
