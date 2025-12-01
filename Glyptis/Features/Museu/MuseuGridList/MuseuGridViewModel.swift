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
    
    var sculptures: [Sculpture] = []
    
    private var context: ModelContext
    let service: SculptureService
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)
    
    init(context: ModelContext, service: SculptureService) {
        self.context = context
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
        sculptures = service.fetchAll()
    }
}
