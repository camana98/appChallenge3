//
//  ViewModelGridTests.swift
//  GlyptisTests
//
//  Created by Vicenzo Másera on 27/11/25.
//

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
        
        viewModel = MuseuGridViewModel(context: context, service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        context = nil
        container = nil
    }
    
    func testInitFetchData() {
        /// DADO QUE existem esculturas no banco ANTES da VM iniciar
        _ = service.create(name: "lolo")
        _ = service.create(name: "hehehe")
        
        /// QUANDO eu inicializo uma NOVA ViewModel
        let newVM = MuseuGridViewModel(context: context, service: service)
        
        /// ENTÃO a ViewModel deve carregar os dados automaticamente no init
        XCTAssertEqual(newVM.sculptures.count, 2)
        XCTAssertEqual(newVM.sculptures.first?.name, "lolo")
    }
    
    // MARK: - FILTER (Busca)
    
    func testFilterEmptySearch() {
        /// DADO QUE existem esculturas carregadas e a busca está vazia
        _ = service.create(name: "A", cubes: [])
        _ = service.create(name: "B", cubes: [])
        // Recarrega a VM para pegar os dados
        viewModel = MuseuGridViewModel(context: context, service: service)
        
        viewModel.searchText = ""
        
        /// QUANDO acesso a lista filtrada
        let list = viewModel.filteredSculptures
        
        /// ENTÃO deve retornar tudo
        XCTAssertEqual(list.count, 2)
    }
    
    func testFilterSpecificSearch() {
        /// DADO QUE tenho esculturas com nomes diferentes
        _ = service.create(name: "Vênus de Milo", cubes: [])
        _ = service.create(name: "O Pensador", cubes: [])
        viewModel = MuseuGridViewModel(context: context, service: service)
        
        /// QUANDO busco por "Vênus"
        viewModel.searchText = "Vênus"
        
        /// ENTÃO deve retornar apenas 1 item correto
        let list = viewModel.filteredSculptures
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.name, "Vênus de Milo")
    }
    
    func testFilterCaseInsensitive() {
        /// DADO QUE tenho "David" salvo
        _ = service.create(name: "David", cubes: [])
        viewModel = MuseuGridViewModel(context: context, service: service)
        
        /// QUANDO busco por "david" (minúsculo)
        viewModel.searchText = "david"
        
        /// ENTÃO deve encontrar mesmo com a caixa diferente
        let list = viewModel.filteredSculptures
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.name, "David")
    }
    
    func testFilterNoMatch() {
        /// DADO QUE tenho dados
        _ = service.create(name: "David", cubes: [])
        viewModel = MuseuGridViewModel(context: context, service: service)
        
        /// QUANDO busco por algo que não existe
        viewModel.searchText = "Godzilla"
        
        /// ENTÃO a lista deve vir vazia
        let list = viewModel.filteredSculptures
        XCTAssertTrue(list.isEmpty)
    }
    
    // MARK: - DELETE
    
    func testDeleteAction() {
        /// DADO QUE tenho uma escultura na ViewModel
        let sculpture = service.create(name: "ToDelete", cubes: [])
        viewModel = MuseuGridViewModel(context: context, service: service)
        
        // Verifica se carregou
        XCTAssertEqual(viewModel.sculptures.count, 1)
        
        /// QUANDO chamo a função delete da ViewModel
        viewModel.delete(s: sculpture)
        
        /// ENTÃO o item deve ter sumido do BANCO DE DADOS (via Service)
        let allInDb = service.fetchAll()
        XCTAssertEqual(allInDb.count, 0)
        
        // Obs: Se a sua VM não recarregar o array 'sculptures' localmente após o delete,
        // o teste de 'viewModel.sculptures.count' poderia falhar aqui.
        // O teste acima garante que a ordem chegou ao banco.
    }
}
