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
    
    //MARK: Logica pra salvar os cubos da escultura
    
    /// 1) Função PURA: só converte UnfinishedCube -> Cube
    private func makeCubes(
        for sculpture: Sculpture,
        from unfinishedCubes: [UnfinishedCube]
    ) -> [Cube] {
        return unfinishedCubes.map { u in
            Cube(
                sculpture: sculpture,
                x: u.locationX,
                y: u.locationY,
                z: u.locationZ,
                r: u.colorR,
                g: u.colorG,
                b: u.colorB
            )
        }
    }

    /// 2) Função que INSERE os cubes no context
    private func insertCubesIntoContext(_ cubes: [Cube]) {
        for cube in cubes {
            context.insert(cube)
        }
    }
    
    
    // MARK: - CREATE
    
    func create(
        name: String,
        author: Author?,
        localization: Localization?,
        cubes unfinishedCubes: [UnfinishedCube],
        snapshot: Data
    ) -> Sculpture {

        let sculpture = Sculpture(name: name, localization: localization.map { [$0] }, author: author, snapshot: snapshot)

        // 1) Insere a escultura no contexto
        context.insert(sculpture)

        // 2) Cria os cubes
        let newCubes = makeCubes(
            for: sculpture,
            from: unfinishedCubes
        )

        // 3) Atualiza a relação na sculpture
        sculpture.cubes = newCubes

        // 4) Insere os cubes no contexto
        insertCubesIntoContext(newCubes)
    
        // 5) Salva
        do {
            try context.save()
            let fetchDescriptor = FetchDescriptor<Sculpture>(sortBy: [SortDescriptor(\.name, order: .reverse)])
            let result = try? context.fetch(fetchDescriptor)
            print("testando aqui \(result)")
        } catch {
            print("Erro ao salvar escultura:", error)
        }

        return sculpture
    }
    
    // MARK: - READ
    
    /// Buscar todas
    func fetchAll() -> [Sculpture] {
        let descriptor = FetchDescriptor<Sculpture>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let fetchDescriptor = FetchDescriptor<Sculpture>(sortBy: [SortDescriptor(\.name, order: .reverse)])
        let result = try? context.fetch(fetchDescriptor)
        print("testando aqui \(result)")
        
        let result2 = try? context.fetch(descriptor)
        print("testando aqui 2 \(result2)")
        
        return (try? context.fetch(descriptor)) ?? []
    }
    
    /// Buscar por ID
    func fetchByID(_ id: UUID) -> Sculpture? {
        let predicate = #Predicate<Sculpture> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        return try? context.fetch(descriptor).first
    }
    
    /// Get snapshot da Sculpture
    func getSnapshot(sculpture: Sculpture) -> Data? {
        return sculpture.snapshot
    }
    
    // MARK: - UPDATE

        /// Atualiza SOMENTE o nome
        func updateName(
            _ sculpture: Sculpture,
            to newName: String
        ) {
            sculpture.name = newName
            do {
                try context.save()
            } catch {
                print("Erro ao trocar nome da escultura:", error)
            }
        }
        
        /// Atualiza SOMENTE os cubos da escultura
        /// Estratégia: apaga os cubes atuais e recria a partir dos UnfinishedCube
        func updateCubes(
            for sculpture: Sculpture,
            with unfinishedCubes: [UnfinishedCube]
        ) {
            // 1) Remove cubes antigos do contexto
            for cube in sculpture.cubes ?? [] {
                context.delete(cube)
            }
            
            // 2) Cria novos cubes a partir dos unfinished
            let newCubes = makeCubes(
                for: sculpture,
                from: unfinishedCubes
            )
            
            // 3) Atualiza relação na sculpture
            sculpture.cubes = newCubes
            
            // 4) Insere novos cubes no contexto
            insertCubesIntoContext(newCubes)
            
            // 5) Salva
            do {
                try context.save()
            } catch {
                print("Erro ao salvar novos cubos da escultura:", error)
            }
        }
        
        /// Atualiza SOMENTE o estado de favorito
        func updateFavorite(
            _ sculpture: Sculpture,
            to isFavorite: Bool
        ) {
            sculpture.isFavorite = isFavorite
            do {
                try context.save()
            } catch {
                print("Erro ao atualizar favorito da escultura:", error)
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

