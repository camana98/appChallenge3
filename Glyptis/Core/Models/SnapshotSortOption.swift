//
//  SnapshotSortOption.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 04/12/25.
//


enum SnapshotSortOption: String, CaseIterable, Identifiable {
    case newestFirst = "Mais Recente Primeiro"
    case oldestFirst = "Mais Antigas Primeiro"
    case nameAZ = "Nome Crescente (A–Z)"

    var id: String { rawValue }
}
