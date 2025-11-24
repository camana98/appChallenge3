import SwiftUI
import RealityKit

struct CanvasView: View {
    /// Estados da UI
    @State private var removeMode: Bool = false
    @State private var selectedColor: Color = .green
    @State private var rotationY: Float = 0.0
    
    /// Opções de cor
    private let colorOptions: [Color] = [.red, .green, .blue, .yellow, .orange, .purple, .cyan, .brown, .white, .black]
    
    var body: some View {
        ZStack {
            Image("backgroundCanvas")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            /// Coluna + Grid
            UnifiedCanvasContainer(
                removeMode: $removeMode,
                selectedColor: $selectedColor,
                rotationY: $rotationY,
                usdzFileName: "canvasColumn",
                modelScale: 0.013,
                modelOffset: SIMD3<Float>(0, -3.9, 0)
            )
            .edgesIgnoringSafeArea(.all)
            
            /// UI de Controles (Overlay)
            VStack {
                /// Botão Remover
                HStack {
                    Spacer()
                    Button(action: { removeMode.toggle() }) {
                        Text(removeMode ? "Modo: REMOVER" : "Modo: ADICIONAR")
                            .font(.headline)
                            .padding()
                            .background(removeMode ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                /// Seletor de Cores
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(colorOptions, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: selectedColor == color ? 4 : 0)
                                )
                                .shadow(radius: 3)
                                .onTapGesture {
                                    selectedColor = color
                                    removeMode = false 
                                }
                        }
                    }
                    .padding()
                }
                .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark))
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
