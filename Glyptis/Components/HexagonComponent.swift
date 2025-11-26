//
//  HexagonComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import Foundation
import SwiftUI

struct RootHexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3
            let x = center.x + radius * sin(angle)
            let y = center.y + radius * cos(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct Hexagon: View {
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
            if isSelected {
                RootHexagon()
                    .foregroundColor(.green)
            }
            RootHexagon()
                .foregroundColor(.gray)
                .scaleEffect(isSelected ? 0.8 : 1)
        }
    }
}

#Preview {
    Hexagon(isSelected: .constant(true))
}
