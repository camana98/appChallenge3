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
    func fetchData()
    func getSnapshot(s: Sculpture) -> UIImage
}


@MainActor
@Observable
class MuseuViewModel: MuseuViewModelProtocol {
    
    let service: SwiftDataService
    var sculptures: [Sculpture] = []
    
    init(service: SwiftDataService) {
        self.service = service
    }
    
    func delete(s: Sculpture) {
        service.delete(s)
    }
    func edit(s: Sculpture) {
        // TODO: fazer funcao de edit
    }
    
    func getSnapshot(s: Sculpture) -> UIImage {
        
        guard let snapshot = service.getSnapshot(sculpture: s) else {
            print("zuuum")
            return UIImage()
        }
        guard let uiImage = UIImage(data: snapshot) else {
            print("opaaaaa")
            return UIImage()
        }
        
        return uiImage
    }
    
    func anchor(s: Sculpture) {
        // TODO: fazer funcao de ancorar
    }
    
    func fetchData() {
        sculptures = service.fetchAll()
    }
}
