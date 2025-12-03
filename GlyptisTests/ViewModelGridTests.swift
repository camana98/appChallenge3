//
//  ViewModelGridTests.swift
//  GlyptisTests
//
//  Created by Vicenzo Másera on 27/11/25.
//

// MuseuGridViewModelTests.swift

import XCTest
import SwiftData
@testable import Glyptis

@MainActor
final class MuseuGridViewModelTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!
    var service: SculptureService!
    var viewModel: MuseuGridViewModel!

    override func setUp() async throws {
        container = try ModelContainer(
            for: Sculpture.self, Author.self, Localization.self, Cube.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        context = ModelContext(container)
        service = await SculptureService(context: context)
        
        // Inicializa a ViewModel (AGORA SEGURO, pois o init está vazio de lógica)
        viewModel = MuseuGridViewModel(context: context, service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        context = nil
        container = nil
    }
    
    func testInitFetchData() {
        // 1. Cria dados no banco
        _ = service.create(name: "lolo", author: Author(name: "Author"), localization: nil, cubes: [])
        _ = service.create(name: "hehehe", author: Author(name: "Author"), localization: nil, cubes: [])
        
        // 2. A VM já foi iniciada no setUp, mas está vazia.
        // Chamamos o fetch manualmente:
        viewModel.fetchData()
        
        // 3. Verifica
        XCTAssertEqual(viewModel.sculptures.count, 2)
        XCTAssertEqual(viewModel.sculptures.first?.name, "hehehe")
    }
    
    func testFilterEmptySearch() {
        _ = service.create(name: "A", author: Author(name: "Author"), localization: nil, cubes: [])
        _ = service.create(name: "B", author: Author(name: "Author"), localization: nil, cubes: [])
        
        viewModel.fetchData() // Carrega os dados
        
        viewModel.searchText = ""
        
        let list = viewModel.filteredSculptures
        XCTAssertEqual(list.count, 2)
    }
    
    func testFilterSpecificSearch() {
        _ = service.create(name: "guigo", author: Author(name: "Author"), localization: nil, cubes: [])
        _ = service.create(name: "Ohahahaha", author: Author(name: "Author"), localization: nil, cubes: [])
        
        viewModel.fetchData()
        
        viewModel.searchText = "gui"
        
        let list = viewModel.filteredSculptures
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.name, "guigo")
    }
    
    func testFilterCaseInsensitive() {
        _ = service.create(name: "pedro", author: Author(name: "Author"), localization: nil, cubes: [])
        
        viewModel.fetchData()
        
        viewModel.searchText = "PEDRO"
        
        let list = viewModel.filteredSculptures
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.name, "pedro")
    }
    
    func testFilterNoMatch() {
        _ = service.create(name: "pedro", author: Author(name: "Author"), localization: nil, cubes: [])
        
        viewModel.fetchData()
        
        viewModel.searchText = "Godzilla"
        
        let list = viewModel.filteredSculptures
        XCTAssertTrue(list.isEmpty)
    }
    
    func testDeleteAction() {
        let sculpture = service.create(name: "ToDelete", author: Author(name: "Author"), localization: nil, cubes: [])
        
        viewModel.fetchData()
        XCTAssertEqual(viewModel.sculptures.count, 1)
        
        viewModel.delete(s: sculpture)
        
        let allInDb = service.fetchAll()
        XCTAssertEqual(allInDb.count, 0)
    }
}

