//
//  SnapshotListView.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 02/12/25.
//

import SwiftUI


struct SnapshotListView: View {

    @StateObject private var viewModel = SnapshotListViewModel()

    var body: some View {
        List(viewModel.snapshots, id: \.self) { url in
            if let image = SnapshotBrowserService.loadImage(from: url) {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)

                    Text(url.lastPathComponent)
                        .font(.caption)
                }
            }
        }
        .onAppear {
            viewModel.loadSnapshots()
        }
        .navigationTitle("Snapshots Salvos")
    }
}
