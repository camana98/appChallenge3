//
//  SnapshotSortOption.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 04/12/25.
//


enum SnapshotSortOption: String, Identifiable, CaseIterable {
    case newestFirst = "Mais Recente Primeiro"
    case oldestFirst = "Mais Antigas Primeiro"
    case nameAZ = "Nome Crescente (A–Z)"
    case nameZA = "Nome Decrescente (Z–A)"
    case favorites = "Somente favoritos"

    var id: String { return self.rawValue }
}
