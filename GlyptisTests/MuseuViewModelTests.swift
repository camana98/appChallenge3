//
//  MuseuViewModelTests.swift
//  GlyptisTests
//
//  Created by Eduardo Camana on 03/12/25.
//

import XCTest
import SwiftData
@testable import Glyptis

@MainActor
final class MuseuViewModelTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!
    var service: SculptureService!
    var viewModel: MuseuViewModel!

    override func setUp() async throws {
        container = try ModelContainer(
            for: Sculpture.self, Author.self, Localization.self, Cube.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        context = ModelContext(container)
        service = SculptureService(context: context)
        
        viewModel = MuseuViewModel(context: context, service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        context = nil
        container = nil
    }
    
    // MARK: - Test Initialization
    
    func testInitialization() {
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.sculptures.isEmpty)
        XCTAssertNotNil(viewModel.service)
    }
    
    // MARK: - Test Fetch Data
    
    func testFetchData() {
        // 1. Cria dados no banco
        _ = service.create(name: "Escultura 1", author: Author(name: "Author"), localization: nil, cubes: [])
        _ = service.create(name: "Escultura 2", author: Author(name: "Author"), localization: nil, cubes: [])
        
        // 2. Verifica que a lista está vazia antes do fetch
        XCTAssertTrue(viewModel.sculptures.isEmpty)
        
        // 3. Chama o fetch
        viewModel.fetchData()
        
        // 4. Verifica que as esculturas foram carregadas
        XCTAssertEqual(viewModel.sculptures.count, 2)
        XCTAssertEqual(viewModel.sculptures.first?.name, "Escultura 2") // Ordenado por createdAt desc
    }
    
    func testFetchDataEmpty() {
        // Quando não há esculturas no banco
        viewModel.fetchData()
        
        XCTAssertTrue(viewModel.sculptures.isEmpty)
    }
    
    func testFetchDataMultipleCalls() {
        // Cria uma escultura
        _ = service.create(name: "Primeira", author: Author(name: "Author"), localization: nil, cubes: [])
        viewModel.fetchData()
        XCTAssertEqual(viewModel.sculptures.count, 1)
        
        // Cria mais esculturas
        _ = service.create(name: "Segunda", author: Author(name: "Author"), localization: nil, cubes: [])
        _ = service.create(name: "Terceira", author: Author(name: "Author"), localization: nil, cubes: [])
        
        // Fetch novamente
        viewModel.fetchData()
        XCTAssertEqual(viewModel.sculptures.count, 3)
    }
    
    // MARK: - Test Delete
    
    func testDeleteSculpture() {
        // 1. Cria uma escultura
        let sculpture = service.create(name: "Para Deletar", author: Author(name: "Author"), localization: nil, cubes: [])
        
        // 2. Carrega os dados
        viewModel.fetchData()
        XCTAssertEqual(viewModel.sculptures.count, 1)
        
        // 3. Deleta a escultura
        viewModel.delete(s: sculpture)
        
        // 4. Verifica que foi deletada do banco
        let allInDb = service.fetchAll()
        XCTAssertEqual(allInDb.count, 0)
        
        // 5. Atualiza a lista local
        viewModel.fetchData()
        XCTAssertTrue(viewModel.sculptures.isEmpty)
    }
    
    func testDeleteMultipleSculptures() {
        // 1. Cria múltiplas esculturas
        let sculpture1 = service.create(name: "Uma", author: Author(name: "Author"), localization: nil, cubes: [])
        let sculpture2 = service.create(name: "Duas", author: Author(name: "Author"), localization: nil, cubes: [])
        let sculpture3 = service.create(name: "Tres", author: Author(name: "Author"), localization: nil, cubes: [])
        
        viewModel.fetchData()
        XCTAssertEqual(viewModel.sculptures.count, 3)
        
        // 2. Deleta uma escultura
        viewModel.delete(s: sculpture2)
        
        // 3. Verifica que restam 2 no banco
        let allInDb = service.fetchAll()
        XCTAssertEqual(allInDb.count, 2)
        XCTAssertTrue(allInDb.contains { $0.id == sculpture1.id })
        XCTAssertTrue(allInDb.contains { $0.id == sculpture3.id })
        XCTAssertFalse(allInDb.contains { $0.id == sculpture2.id })
    }
    
    // MARK: - Test Edit (Placeholder)
    
    func testEditSculpture() {
        // A função edit ainda não está implementada (TODO)
        let sculpture = service.create(name: "Para Editar", author: Author(name: "Author"), localization: nil, cubes: [])
        
        // Verifica que a função existe e não quebra
        viewModel.edit(s: sculpture)
        
        // Por enquanto, apenas verifica que a escultura ainda existe
        let fetched = service.fetchByID(sculpture.id)
        XCTAssertNotNil(fetched)
    }
    
    // MARK: - Test Anchor (Placeholder)
    
    func testAnchorSculpture() {
        // A função anchor ainda não está implementada (TODO)
        let sculpture = service.create(name: "Para Ancorar", author: Author(name: "Author"), localization: nil, cubes: [])
        
        // Verifica que a função existe e não quebra
        viewModel.anchor(s: sculpture)
        
        // Por enquanto, apenas verifica que a escultura ainda existe
        let fetched = service.fetchByID(sculpture.id)
        XCTAssertNotNil(fetched)
    }
}

