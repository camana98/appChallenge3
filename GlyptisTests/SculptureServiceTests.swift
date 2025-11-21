//
//  SculptureServiceTest.swift
//  appChallenge3
//
//  Created by Guilherme Ghise Rossoni on 19/11/25.
//

import XCTest
import SwiftData
@testable import Glyptis

final class SculptureServiceTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!
    var service: SculptureService!

    // MARK: - Setup
    
    /// Roda ANTES de cada teste
    override func setUp() async throws {
        container = try ModelContainer(
            for: Sculpture.self, Author.self, Localization.self, Cube.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        context = ModelContext(container)
        service = SculptureService(context: context)
    }

    /// Roda DEPOIS de cada teste
    override func tearDown() {
        container = nil
        context = nil
        service = nil
    }
    
    // MARK: - CREATE
    
    func testCreateSculpture() throws {
        /// DADO QUE quero criar uma nova escultura
        /// QUANDO eu chamo o método create()
        let sculpture = service.create(
            name: "Minha Escultura",
            author: nil,
            localization: nil,
            cubes: []
        )
        
        /// ENTÃO a escultura deve ser criada com ID e nome corretos
        XCTAssertNotNil(sculpture.id)
        XCTAssertEqual(sculpture.name, "Minha Escultura")

        /// ENTÃO ela deve estar salva no banco
        let all = service.fetchAll()
        XCTAssertEqual(all.count, 1)
    }

    // MARK: - READ (Buscar todas)
    
    func testFetchAll() throws {
        /// DADO QUE existem 2 esculturas salvas
        _ = service.create(name: "A", cubes: [])
        _ = service.create(name: "B", cubes: [])

        /// QUANDO eu busco todas
        let all = service.fetchAll()

        /// ENTÃO devo receber as 2 esculturas
        XCTAssertEqual(all.count, 2)
    }

    // MARK: - READ (Buscar por ID)
    
    func testFetchByID() throws {
        /// DADO QUE existe uma escultura salva
        let created = service.create(name: "Test", cubes: [])
        
        /// QUANDO eu busco pela mesma pelo ID dela
        let fetched = service.fetchByID(created.id)

        /// ENTÃO ela deve ser encontrada e ter o mesmo ID
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, created.id)
    }

    // MARK: - UPDATE
    
    func testUpdateSculpture() throws {
        /// DADO QUE tenho uma escultura com nome "Old"
        let sculpture = service.create(name: "Old", cubes: [])

        /// QUANDO eu atualizo o nome para "New"
        service.update(sculpture: sculpture, newName: "New")

        /// ENTÃO o nome deve estar atualizado no banco
        let updated = service.fetchByID(sculpture.id)
        XCTAssertEqual(updated?.name, "New")
    }

    // MARK: - DELETE
    
    func testDeleteSculpture() throws {
        /// DADO QUE tenho uma escultura salva
        let sculpture = service.create(name: "ToDelete", cubes: [])

        /// QUANDO eu a deleto
        service.delete(sculpture)

        /// ENTÃO ela não deve mais existir no banco
        let all = service.fetchAll()
        XCTAssertEqual(all.count, 0)
    }
}
