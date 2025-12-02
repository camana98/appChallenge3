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
    let id: Int
    let isSelected: Bool
    let hexagonColor: Color
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            if isSelected {
                RootHexagon()
                    .foregroundColor(.white)
            }
            RootHexagon()
                .foregroundColor(hexagonColor)
                .scaleEffect(isSelected ? 0.8 : 1)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    RootHexagon()
//    Hexagon(isSelectedNotifier: .constant(UUID()), hexagonColor: .red)
}
