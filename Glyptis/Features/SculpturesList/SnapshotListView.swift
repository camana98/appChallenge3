//
//  SnapshotListView.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 02/12/25.
//

import SwiftUI


struct SnapshotListView: View {

    @StateObject private var viewModel = SnapshotListViewModel()
    @State private var showToolbox: Bool = false
    @State private var showConfirmClear: Bool = false

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Minhas Esculturas")
                        .font(.custom("AngleSquareDEMO", size: 28))
                        .foregroundColor(.primary)
                    Text("Filtro: Mais Recentes Primeiro")
                        .font(.custom("NotoSans-Regular", size: 14))
                        .foregroundColor(.primary)
                }
                Spacer()
                Button(action: { showConfirmClear = true }) {
                    VStack(spacing: 6) {
                        SimpleCubeIcon(
                            assetName: "filterCube",
                            width: 44,
                            height: 46
                        ) {
                            showConfirmClear = true
                        }
                    }
                }
            }
            .padding()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.snapshots, id: \.self) { url in
                        if let image = SnapshotBrowserService.loadImage(from: url) {
                            VStack {
                                VStack {
                                    Spacer()
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 108, height: 108)
                                        .clipped()
                                        .cornerRadius(12)
                                }
                                .frame(width: 108, height: 130)
                                .background(
                                    Image("bezeled")
                                        .resizable()
                                        .scaledToFill()
                                )
                                Text(url.lastPathComponent)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.loadSnapshots()
            }
        }
        .background(.ultraThinMaterial.opacity(0.5))
        .navigationTitle("Snapshots Salvos")
    }

}

#Preview {
    SnapshotListView()
}
