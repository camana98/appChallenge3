//
//  ArtworksListView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI

struct ArtworksListView: View {
    let artworks: [PixelArt]
    let onSelect: (PixelArt) -> Void
    let onDelete: (PixelArt) -> Void
    let onViewAR: (PixelArt) -> Void
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(artworks) { artwork in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(artwork.name)
                                .font(.headline)
                            Text(artwork.timestamp, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Button(action: { onViewAR(artwork) }) {
                                Image(systemName: "arkit")
                                    .foregroundColor(.purple)
                                    .font(.title3)
                            }
                            
                            Button(action: { onSelect(artwork) }) {
                                Image(systemName: "arrow.down.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive, action: { onDelete(artwork) }) {
                            Label("Deletar", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Meus Desenhos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

