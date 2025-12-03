//
//  ColorPickerComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import SwiftUI

// MARK: - 1. Preference Key & Data
struct HexagonFrameData: Equatable {
    let id: Int
    let center: CGPoint
}

struct HexagonFramePreferenceKey: PreferenceKey {
    static var defaultValue: [HexagonFrameData] = []
    static func reduce(value: inout [HexagonFrameData], nextValue: () -> [HexagonFrameData]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - 2. Forma do Hexágono
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let x = rect.minX
        let y = rect.minY
        
        path.move(to: CGPoint(x: x + width * 0.25, y: y))
        path.addLine(to: CGPoint(x: x + width * 0.75, y: y))
        path.addLine(to: CGPoint(x: x + width, y: y + height * 0.5))
        path.addLine(to: CGPoint(x: x + width * 0.75, y: y + height))
        path.addLine(to: CGPoint(x: x + width * 0.25, y: y + height))
        path.addLine(to: CGPoint(x: x, y: y + height * 0.5))
        path.closeSubpath()
        return path
    }
}

// MARK: - 3. Componente Principal
struct ColorPickerComponent: View {
    @State var selectedHexID: Int?
    @Binding var selectedColor: Color
    
    var onColorSelected: () -> Void
    
    var beehiveSize: CGFloat = 32
    
    @State private var hexagonPositions: [HexagonFrameData] = []
    
    private var hiveLines: [[HexColor]] {
        [
            ColorPalete.line1, ColorPalete.line2, ColorPalete.line3,
            ColorPalete.line4, ColorPalete.line5, ColorPalete.line6,
            ColorPalete.line7, ColorPalete.line8, ColorPalete.line9,
            ColorPalete.line10, ColorPalete.line11, ColorPalete.line12,
            ColorPalete.line13
        ]
    }
    
    var body: some View {
        let horizontalOverlap = beehiveSize * (0.866 - 1)
        let verticalOverlap   = beehiveSize * 0.25
        
        // ESTE VStack AGORA CONTROLA O GESTO GLOBAL
        VStack(spacing: 24) {
            
            Text("Alterar cor")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            /// --- 1. Favo Principal ---
            VStack(spacing: -verticalOverlap) {
                ForEach(hiveLines.indices, id: \.self) { rowIndex in
                    HStack(spacing: horizontalOverlap) {
                        ForEach(hiveLines[rowIndex]) { hexColor in
                            hexagonView(for: hexColor)
                        }
                    }
                    .zIndex(Double(hiveLines.count - rowIndex))
                }
            }
            
            /// --- 2. Escala de Cinza e Preview ---
            HStack(spacing: 24) {
                VStack(spacing: -verticalOverlap) {
                    HStack(spacing: horizontalOverlap) {
                        ForEach(ColorPalete.line14) { hexColor in
                            hexagonView(for: hexColor)
                        }
                    }
                    .zIndex(2)
                    
                    HStack(spacing: horizontalOverlap) {
                        ForEach(ColorPalete.line15) { hexColor in
                            hexagonView(for: hexColor)
                        }
                    }
                    .zIndex(1)
                }
                
                /// Preview Grande (Não interativo)
                RootHexagon()
                    .fill(selectedColor)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    .frame(width: 50, height: 50)
            }
        }
        .accessibilityIdentifier("ColorPickerComponent")
        /// --- CONFIGURAÇÃO DO GESTO  ---
        .coordinateSpace(name: "HoneycombSpace")
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    detectColor(at: value.location)
                }
        )
        /// Coleta as posições de TODOS os hexágonos
        .onPreferenceChange(HexagonFramePreferenceKey.self) { preferences in
            self.hexagonPositions = preferences
        }
    }
    
    // MARK: - Lógica de Detecção
    
    private func detectColor(at location: CGPoint) {
        if let closest = hexagonPositions.min(by: { dist($0.center, location) < dist($1.center, location) }) {
            
            if dist(closest.center, location) < (beehiveSize * 1.2) {
                
                if selectedHexID != closest.id {
                    let allMainColors = hiveLines.flatMap { $0 }
                    let grayScaleColors = ColorPalete.line14 + ColorPalete.line15
                    let totalColors = allMainColors + grayScaleColors
                    
                    if let match = totalColors.first(where: { $0.id == closest.id }) {
                        selectedColor = match.color
                        selectedHexID = closest.id
                        
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }
            }
        }
    }
    
    private func dist(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        return hypot(a.x - b.x, a.y - b.y)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func hexagonView(for hexColor: HexColor) -> some View {
        let isSelected = selectedHexID == hexColor.id
        
        ZStack {
            if isSelected {
                RootHexagon().foregroundColor(.white)
            }
            RootHexagon()
                .foregroundColor(hexColor.color)
                .scaleEffect(isSelected ? 0.8 : 1)
        }
        .frame(width: beehiveSize, height: beehiveSize)
        .contentShape(HexagonShape())
        .zIndex(isSelected ? 1 : 0)
        /// Registra a posição para o DragGesture global
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: HexagonFramePreferenceKey.self,
                    value: [HexagonFrameData(
                        id: hexColor.id,
                        center: geo.frame(in: .named("HoneycombSpace")).center
                    )]
                )
            }
        )
    }
}

// Helper
extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
