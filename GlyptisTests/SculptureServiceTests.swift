////
////  SculptureServiceTest.swift
////  appChallenge3
////
////  Created by Guilherme Ghise Rossoni on 19/11/25.
////

import XCTest
import SwiftData
@testable import Glyptis

@MainActor
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
        service = await SculptureService(context: context)
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
        let initialCount = service.fetchAll().count
        
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

        /// ENTÃO o total de esculturas deve ter aumentado em 1
        let all = service.fetchAll()
        XCTAssertEqual(all.count, initialCount + 1)
    }

    // MARK: - READ (Buscar todas)
    
    func testFetchAll() throws {
        /// DADO QUE existem esculturas salvas
        let initialCount = service.fetchAll().count
        
        _ = service.create(name: "A", author: Author(name: "Author"), localization: nil, cubes: [])
        _ = service.create(name: "B", author: Author(name: "Author"), localization: nil, cubes: [])

        /// QUANDO eu busco todas
        let all = service.fetchAll()

        /// ENTÃO devo receber +2 esculturas em relação ao total inicial
        XCTAssertEqual(all.count, initialCount + 2)
    }

    // MARK: - READ (Buscar por ID)
    
    func testFetchByID() throws {
        /// DADO QUE existe uma escultura salva
        let created = service.create(name: "Test", author: Author(name: "Author"), localization: nil, cubes: [])
        
        /// QUANDO eu busco pela mesma pelo ID dela
        let fetched = service.fetchByID(created.id)

        /// ENTÃO ela deve ser encontrada e ter o mesmo ID
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.id, created.id)
    }

    // MARK: - UPDATE (nome)

    func testUpdateName() throws {
        /// DADO QUE tenho uma escultura com nome "Old"
        let sculpture = service.create(name: "Old", author: Author(name: "Author"), localization: nil, cubes: [])

        /// QUANDO eu atualizo o nome para "New"
        service.updateName(sculpture, to: "New")

        /// ENTÃO o nome deve estar atualizado no banco
        let updated = service.fetchByID(sculpture.id)
        XCTAssertEqual(updated?.name, "New")
    }

    // MARK: - UPDATE (cubos)

    func testUpdateCubes() throws {
        /// DADO QUE tenho uma escultura com 1 cubo
        let initialUnfinishedCubes = [
            UnfinishedCube(
                locationX: 0,
                locationY: 0,
                locationZ: 0,
                colorR: 1,
                colorG: 0,
                colorB: 0,
                colorA: 0
            )
        ]
        
        let sculpture = service.create(
            name: "WithCubes",
            author: Author(name: "Author"),
            localization: nil,
            cubes: initialUnfinishedCubes
        )
        
        XCTAssertEqual(sculpture.cubes?.count, 1)

        /// QUANDO eu atualizo os cubos com uma nova lista
        let newUnfinishedCubes = [
            UnfinishedCube(
                locationX: 1,
                locationY: 1,
                locationZ: 1,
                colorR: 0,
                colorG: 1,
                colorB: 0,
                colorA: 0
            ),
            UnfinishedCube(
                locationX: 2,
                locationY: 2,
                locationZ: 2,
                colorR: 0,
                colorG: 0,
                colorB: 1,
                colorA: 0
            )
        ]
        
        service.updateCubes(for: sculpture, with: newUnfinishedCubes)
        
        /// ENTÃO a escultura deve ter os novos cubos no banco
        guard let updated = service.fetchByID(sculpture.id) else {
            XCTFail("Escultura não foi encontrada após updateCubes")
            return
        }
        
        let cubes = updated.cubes ?? []
        XCTAssertEqual(cubes.count, 2)

        XCTAssertTrue(cubes.contains { $0.locationX == 1 && $0.locationY == 1 && $0.locationZ == 1 })
        XCTAssertTrue(cubes.contains { $0.locationX == 2 && $0.locationY == 2 && $0.locationZ == 2 })
    }

    // MARK: - DELETE
    
    func testDeleteSculpture() throws {
        /// DADO QUE tenho uma escultura salva
        let initialCount = service.fetchAll().count
        
        let sculpture = service.create(
            name: "ToDelete",
            author: Author(name: "Author"),
            localization: nil,
            cubes: []
        )

        /// QUANDO eu a deleto
        service.delete(sculpture)

        /// ENTÃO o total deve voltar ao mesmo valor inicial
        let all = service.fetchAll()
        XCTAssertEqual(all.count, initialCount)
    }
}
