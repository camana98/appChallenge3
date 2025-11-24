//
//  LocalizationService.swift
//  Glyptis
//
//  Created by Eduardo Camana on 24/11/25.
//

import Foundation
import SwiftData

//MARK: CRD Service for Localization
final class LocalizationService {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    //MARK: Create
    func create(
        latitude: Double,
        longitude: Double,
        altitude: Double,
        sculpture: Sculpture, //ver com vivico regra de negocio
        contributors: [Author]? = nil
    ) -> Localization {
        let localization = Localization(
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            sculpture: sculpture
        )
        localization.contributors = contributors
        sculpture.localization.append(localization)
        
        context.insert(localization)
        do {
            try context.save()
        } catch {
            print("Erro ao criar localização:", error)
        }
        
        return localization
    }
    
    //MARK: Read
    
    /// Buscar todas
    func fetchAll() -> [Localization] {
        let descriptor = FetchDescriptor<Localization>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
        
        return (try? context.fetch(descriptor)) ?? []
    }
    
    ///Buscar por ID
    func fetchByID(_ id: UUID) -> Localization? {
        let predicate = #Predicate<Localization> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try? context.fetch(descriptor).first
    }
    
    
    //MARK: Delete
    
    func delete(_ localization: Localization) {
        context.delete(localization)
        do {
            try context.save()
        } catch {
            print("Erro ao deletar localização:", error)
        }
    }
    
}
