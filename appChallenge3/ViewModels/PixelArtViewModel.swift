//
//  PixelArtViewModel.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
class PixelArtViewModel: ObservableObject {
    @Published var selectedColor: Color = .black
    @Published var pixels: [[Color]]
    @Published var hue: Double = 0.0
    @Published var saturation: Double = 1.0
    @Published var brightness: Double = 1.0
    @Published var showingSaveDialog = false
    @Published var showingArtworksList = false
    @Published var showingARView = false
    @Published var artworkName = ""
    @Published var isEraserMode = false
    
    let gridSize: Int
    let pixelSize: CGFloat
    
    private var modelContext: ModelContext?
    
    init(gridSize: Int = 16, pixelSize: CGFloat = 20) {
        self.gridSize = gridSize
        self.pixelSize = pixelSize
        self.pixels = Array(repeating: Array(repeating: .white, count: gridSize), count: gridSize)
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    func updateSelectedColor() {
        selectedColor = Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    func setPixel(at row: Int, col: Int, color: Color) {
        guard row >= 0, row < gridSize, col >= 0, col < gridSize else { return }
        pixels[row][col] = color
    }
    
    func clearPixel(at row: Int, col: Int) {
        guard row >= 0, row < gridSize, col >= 0, col < gridSize else { return }
        pixels[row][col] = .white
    }
    
    func clearCanvas() {
        pixels = Array(repeating: Array(repeating: .white, count: gridSize), count: gridSize)
    }
    
    func saveArtwork() {
        guard let modelContext = modelContext else { return }
        
        let pixelData = PixelArt.encodePixels(pixels)
        let artwork = PixelArt(
            name: artworkName.isEmpty ? "Desenho sem título" : artworkName,
            pixelData: pixelData
        )
        modelContext.insert(artwork)
        
        do {
            try modelContext.save()
            showingSaveDialog = false
            artworkName = ""
        } catch {
            print("Erro ao salvar: \(error)")
        }
    }
    
    func loadArtwork(_ artwork: PixelArt) {
        pixels = PixelArt.decodePixels(artwork.pixelData, gridSize: gridSize)
    }
    
    func deleteArtwork(_ artwork: PixelArt, context: ModelContext) {
        context.delete(artwork)
        do {
            try context.save()
        } catch {
            print("Erro ao deletar: \(error)")
        }
    }
}

