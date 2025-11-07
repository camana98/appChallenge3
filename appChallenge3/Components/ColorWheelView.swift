//
//  ColorWheelView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI

struct ColorWheelView: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    @Binding var selectedColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 - 20
            
            ZStack {
                // Roleta de cores usando Canvas
                Canvas { context, size in
                    let centerPoint = CGPoint(x: size.width / 2, y: size.height / 2)
                    let wheelRadius = min(size.width, size.height) / 2 - 20
                    
                    // Desenha a roleta de cores
                    for angle in stride(from: 0, to: 360, by: 1) {
                        let hueValue = Double(angle) / 360.0
                        let startAngle = Angle(degrees: Double(angle))
                        let endAngle = Angle(degrees: Double(angle + 1))
                        
                        var path = Path()
                        path.move(to: centerPoint)
                        path.addArc(
                            center: centerPoint,
                            radius: wheelRadius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                        path.closeSubpath()
                        
                        context.fill(
                            path,
                            with: .color(Color(hue: hueValue, saturation: 1.0, brightness: 1.0))
                        )
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Indicador de seleção
                let angle = hue * 360
                let radian = angle * .pi / 180
                let x = center.x + cos(radian) * radius * saturation
                let y = center.y + sin(radian) * radius * saturation
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 3)
                    )
                    .position(x: x, y: y)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                
                // Controle de brilho no centro
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white,
                                Color(hue: hue, saturation: saturation, brightness: 0.5),
                                Color.black
                            ]),
                            center: .top,
                            startRadius: 0,
                            endRadius: radius * 0.3
                        )
                    )
                    .frame(width: radius * 0.6, height: radius * 0.6)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .shadow(color: .black.opacity(0.3), radius: 2)
                    )
                    .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 12, height: 12)
                            .offset(y: -radius * 0.3 + (1 - brightness) * radius * 0.6)
                            .shadow(radius: 2)
                    )
                    .position(center)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        updateColor(from: value.location, center: center, radius: radius)
                    }
            )
            .onTapGesture { location in
                updateColor(from: location, center: center, radius: radius)
            }
        }
    }
    
    private func updateColor(from location: CGPoint, center: CGPoint, radius: CGFloat) {
        let dx = location.x - center.x
        let dy = location.y - center.y
        let distance = sqrt(dx * dx + dy * dy)
        
        // Se está dentro do círculo de brilho
        if distance < radius * 0.3 {
            let normalizedDistance = distance / (radius * 0.3)
            brightness = max(0.0, min(1.0, 1.0 - normalizedDistance))
            return
        }
        
        // Se está dentro da roleta
        if distance <= radius {
            let angle = atan2(dy, dx)
            var angleDegrees = angle * 180 / .pi
            if angleDegrees < 0 {
                angleDegrees += 360
            }
            hue = max(0.0, min(1.0, angleDegrees / 360.0))
            saturation = max(0.0, min(1.0, distance / radius))
            brightness = 1.0
        }
    }
}

