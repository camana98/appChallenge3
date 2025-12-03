//
//  MuseuViewModel.swift
//  Glyptis
//
//  Created by Eduardo Camana on 03/12/25.
//

import Foundation
import SwiftUI
import SwiftData

protocol MuseuViewModelProtocol {
    var sculptures: [Sculpture] { get set }
    
    func delete(s: Sculpture) -> Void
    func edit(s: Sculpture)  -> Void
    func anchor(s: Sculpture)  -> Void
    func fetchData() -> Void
}



class MuseuViewModel: MuseuViewModelProtocol {
    
    let service: SculptureService
    var sculptures: [Sculpture] = []
    
    private var context: ModelContext
    
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
