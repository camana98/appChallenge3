//
//  PixelArt.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import Foundation
import SwiftData
import SwiftUI
import UIKit


@Model
final class PixelArt: Identifiable {
    var id: UUID
    var name: String
    var timestamp: Date
    var pixelData: String // JSON string com os dados dos pixels
    
    init(name: String = "Desenho sem título", pixelData: String = "", timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.timestamp = timestamp
        self.pixelData = pixelData
    }
    
    // Função auxiliar para converter matriz de cores para string JSON
    static func encodePixels(_ pixels: [[Color]]) -> String {
        let gridSize = pixels.count
        var encodedData: [[String]] = []
        
        for row in pixels {
            var encodedRow: [String] = []
            for color in row {
                // Converter Color para string hex
                let hex = colorToHex(color)
                encodedRow.append(hex)
            }
            encodedData.append(encodedRow)
        }
        
        if let jsonData = try? JSONEncoder().encode(encodedData),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
    
    // Função auxiliar para converter string JSON para matriz de cores
    static func decodePixels(_ jsonString: String, gridSize: Int = 16) -> [[Color]] {
        guard let jsonData = jsonString.data(using: .utf8),
              let decodedData = try? JSONDecoder().decode([[String]].self, from: jsonData) else {
            return Array(repeating: Array(repeating: .white, count: gridSize), count: gridSize)
        }
        
        var pixels: [[Color]] = []
        for row in decodedData {
            var pixelRow: [Color] = []
            for hexString in row {
                pixelRow.append(hexToColor(hexString))
            }
            pixels.append(pixelRow)
        }
        
        return pixels
    }
    
    // Converter Color para hex string
    private static func colorToHex(_ color: Color) -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        
        let nsColor = UIColor(color)
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)
        
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }
    
    // Converter hex string para Color
    private static func hexToColor(_ hex: String) -> Color {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb >> 24) & 0xFF) / 255.0
        let g = Double((rgb >> 16) & 0xFF) / 255.0
        let b = Double((rgb >> 8) & 0xFF) / 255.0
        let a = Double(rgb & 0xFF) / 255.0
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}

