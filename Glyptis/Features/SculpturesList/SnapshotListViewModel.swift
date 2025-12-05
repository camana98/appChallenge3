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
    @Published var sortOptions: SnapshotSortOption = .newestFirst
    @Published var searchText: String = ""

    func loadSnapshots() {
        var files = SnapshotBrowserService.listSnapshots()
        
        switch sortOptions {
        case .newestFirst:
            files.sort(by: { (lhs: URL, rhs: URL) -> Bool in
                (lhs.creationDate ?? .distantPast) > (rhs.creationDate ?? .distantPast)
            })
        case .oldestFirst:
            files.sort(by: { (lhs: URL, rhs: URL) -> Bool in
                (lhs.creationDate ?? .distantPast) < (rhs.creationDate ?? .distantPast)
            })
        case .nameAZ:
            files.sort(by: { (lhs: URL, rhs: URL) -> Bool in
                lhs.lastPathComponent.lowercased() < rhs.lastPathComponent.lowercased()
            })
        case .nameZA:
            files.sort(by: { (lhs: URL, rhs: URL) -> Bool in
                lhs.lastPathComponent.lowercased() > rhs.lastPathComponent.lowercased()
            })
        }
        
        if !searchText.isEmpty {
            files = files.filter {
                $0.lastPathComponent.lowercased()
                    .contains(searchText.lowercased())
            }
        }
        
        snapshots = files
    }
}

extension URL {
    var creationDate: Date? {
        (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
    }
}
