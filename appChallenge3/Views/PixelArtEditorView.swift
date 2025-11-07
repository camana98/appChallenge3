//
//  PixelArtEditorView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI
import SwiftData

struct PixelArtEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PixelArt.timestamp, order: .reverse) private var savedArtworks: [PixelArt]
    @StateObject private var viewModel = PixelArtViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Título
                    Text("Pixel Art Editor")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    // Grade de pixels
                    PixelGridView(
                        pixels: viewModel.pixels,
                        gridSize: viewModel.gridSize,
                        pixelSize: viewModel.pixelSize,
                        onPixelTapped: { row, col in
                            if viewModel.isEraserMode {
                                viewModel.clearPixel(at: row, col: col)
                            } else {
                                viewModel.setPixel(at: row, col: col, color: viewModel.selectedColor)
                            }
                        }
                    )
                    
                    // Seletor de cor em roleta
                    ColorWheelView(
                        hue: $viewModel.hue,
                        saturation: $viewModel.saturation,
                        brightness: $viewModel.brightness,
                        selectedColor: $viewModel.selectedColor
                    )
                    .frame(width: 200, height: 200)
                    
                    // Cor selecionada preview
                    ColorPreviewView(selectedColor: viewModel.selectedColor)
                    
                    // Botões de ação
                    ActionButtonsView(
                        onSave: { viewModel.showingSaveDialog = true },
                        onShowArtworks: { viewModel.showingArtworksList = true },
                        onClear: { viewModel.clearCanvas() },
                        onShowAR: { viewModel.showingARView = true },
                        onToggleEraser: { viewModel.isEraserMode.toggle() },
                        isEraserMode: viewModel.isEraserMode
                    )
                }
                .padding(.horizontal, 16)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 0)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
            .onChange(of: viewModel.hue) { _, _ in
                viewModel.updateSelectedColor()
            }
            .onChange(of: viewModel.saturation) { _, _ in
                viewModel.updateSelectedColor()
            }
            .onChange(of: viewModel.brightness) { _, _ in
                viewModel.updateSelectedColor()
            }
            .sheet(isPresented: $viewModel.showingSaveDialog) {
                SaveDialogView(
                    artworkName: $viewModel.artworkName,
                    onSave: { viewModel.saveArtwork() },
                    onCancel: {
                        viewModel.showingSaveDialog = false
                        viewModel.artworkName = ""
                    }
                )
            }
            .sheet(isPresented: $viewModel.showingArtworksList) {
                ArtworksListView(
                    artworks: savedArtworks,
                    onSelect: { artwork in
                        viewModel.loadArtwork(artwork)
                        viewModel.showingArtworksList = false
                    },
                    onDelete: { artwork in
                        viewModel.deleteArtwork(artwork, context: modelContext)
                    },
                    onViewAR: { artwork in
                        viewModel.loadArtwork(artwork)
                        viewModel.showingArtworksList = false
                        viewModel.showingARView = true
                    }
                )
            }
            .fullScreenCover(isPresented: $viewModel.showingARView) {
                PixelArtARViewContainer(
                    pixels: viewModel.pixels,
                    gridSize: viewModel.gridSize
                )
            }
        }
    }
}

#Preview {
    PixelArtEditorView()
        .modelContainer(for: [PixelArt.self], inMemory: true)
}

