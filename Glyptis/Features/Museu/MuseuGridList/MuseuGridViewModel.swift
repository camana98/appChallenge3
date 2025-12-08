//
//  MuseuGridViewModel.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 27/11/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
@MainActor
class MuseuGridViewModel: MuseuGridViewModelProtocol {
    
    var showSearch: Bool = false
    var searchText: String = ""
    var filteredSculptures: [Sculpture] {
        if searchText.isEmpty {
            return sculptures
        } else {
            return sculptures.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortOptions: SnapshotSortOption = .newestFirst
    
    var sculptures: [Sculpture] = []
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    let service: SwiftDataService
    
    init(service: SwiftDataService) {
        self.service = service
    }
    
    func delete(s: Sculpture) {
        service.delete(s)
    }
    func edit(s: Sculpture) {
        // TODO: fazer funcao de edit
    }
    func anchor(s: Sculpture) {
        // TODO: fazer funcao de ancorar
    }
    
    func fetchData() {
        var esculturasCruas = service.fetchAll()
        
        switch sortOptions {
        case .newestFirst:
            esculturasCruas.sort(by: { (sculpture1: Sculpture, sculpture2: Sculpture) -> Bool in
                sculpture1.createdAt > sculpture2.createdAt
            })
        case .oldestFirst:
            esculturasCruas.sort(by: { (sculpture1: Sculpture, sculpture2: Sculpture) -> Bool in
                sculpture1.createdAt < sculpture2.createdAt
            })
        case .nameAZ:
            esculturasCruas.sort(by: { (sculpture1: Sculpture, sculpture2: Sculpture) -> Bool in
                sculpture1.name.lowercased() > sculpture2.name.lowercased()
            })
        case .nameZA:
            esculturasCruas.sort(by: { (sculpture1: Sculpture, sculpture2: Sculpture) -> Bool in
                sculpture1.name.lowercased() < sculpture2.name.lowercased()
            })
        }
        
        sculptures = esculturasCruas
    }
    
    func getSnapshot(s: Sculpture) -> UIImage {
        
        guard let snapshot = service.getSnapshot(sculpture: s) else {
            return UIImage()
        }
        
        SnapshotService.saveDrawing(data: snapshot)
        
        guard let uiImage = UIImage(data: snapshot) else {
            return UIImage()
        }
        
        return uiImage
    }
}
