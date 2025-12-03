//
//  SnapshotListViewModel.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 02/12/25.
//

import SwiftUI
import Combine

@MainActor
class SnapshotListViewModel: ObservableObject {
    @Published var snapshots: [URL] = []

    func loadSnapshots() {
        snapshots = SnapshotBrowserService.listSnapshots()
    }
}
