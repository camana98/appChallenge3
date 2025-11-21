//
//  SculptureService.swift
//  appChallenge3
//
//  Created by Guilherme Ghise Rossoni on 19/11/25.
//

import Foundation
import SwiftData

final class SculptureService {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - CREATE
    
    func create(
        name: String,
        author: Author? = nil,
        localization: Localization? = nil,
        cubes: [UnfinishedCube] = []
    ) -> Sculpture {
        
        let sculpture = Sculpture(
            name: name,
            author: author
        )
        
        /// Transformar UnfinishedCube em Cube
        var newCubes: [Cube] = []
        
        for u in cubes {
            let cube = Cube(
                sculpture: sculpture,
                x: u.locationX,
                y: u.locationY,
                z: u.locationZ,
                r: u.colorR,
                g: u.colorG,
                b: u.colorB
            )
            newCubes.append(cube)
            context.insert(cube)
        }
        
        sculpture.cubes = newCubes
        
        context.insert(sculpture)
        do {
            try context.save()
        } catch {
            print("Erro ao criar escultura:", error)
        }
        
        return sculpture
    }
    
    // MARK: - READ
    
    /// Buscar todas
    func fetchAll() -> [Sculpture] {
        let descriptor = FetchDescriptor<Sculpture>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        return (try? context.fetch(descriptor)) ?? []
    }
    
    /// Buscar por ID
    func fetchByID(_ id: UUID) -> Sculpture? {
        let predicate = #Predicate<Sculpture> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try? context.fetch(descriptor).first
    }
    
    // MARK: - UPDATE
    
    func update(
        sculpture: Sculpture,
        newName: String? = nil,
        newLocalization: Localization? = nil,
        newAuthor: Author? = nil
    ) {
        
        if let newName { sculpture.name = newName }
        if let newLocalization { sculpture.localization = newLocalization }
        if let newAuthor { sculpture.author = newAuthor }
        
        do {
            try context.save()
        } catch {
            print("Erro ao atualizar escultura:", error)
        }
    }
    
    // MARK: - DELETE
    
    func delete(_ sculpture: Sculpture) {
        context.delete(sculpture)
        
        do {
            try context.save()
        } catch {
            print("Erro ao deletar escultura:", error)
        }
    }
}
