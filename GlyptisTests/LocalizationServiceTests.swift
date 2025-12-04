////
////  LocalizationServiceTests.swift
////  GlyptisTests
////
////  Created by Eduardo Camana on 25/11/25.
////
//
//import XCTest
//import SwiftData
//@testable import Glyptis
//
//final class LocalizationServiceTests: XCTestCase {
//    
//    var container: ModelContainer!
//    var context: ModelContext!
//    var service: LocalizationService!
//    
//    // MARK: - Setup
//    
//    /// Roda ANTES de cada teste
//    override func setUp() async throws {
//        container = try ModelContainer(
//            for: Sculpture.self, Author.self, Localization.self, Cube.self,
//            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//        )
//        
//        context = ModelContext(container)
//        service = await LocalizationService(context: context)
//    }
//    
//    /// Roda DEPOIS de cada teste
//    override func tearDown() {
//        container = nil
//        context = nil
//        service = nil
//    }
//    
//    
//    //MARK: Create
//    
//    func testCreateLocalization() throws {
//        /// DADO QUE quero criar uma nova escultura
//        /// QUANDO eu chamo o método create()
//        let localization = service.create(
//            latitude: 0.0,
//            longitude: 0.0,
//            altitude: 0.0,
//            sculpture: Sculpture(name: "Test")
//        )
//        
//        /// ENTÃO a localizações deve ser criada com ID e dados corretos
//        XCTAssertNotNil(localization.id)
//        XCTAssertEqual(localization.latitude, 0.0)
//        XCTAssertEqual(localization.longitude, 0.0)
//        XCTAssertEqual(localization.altitude, 0.0)
//        XCTAssertEqual(localization.sculpture?.name, "Test")
//
//        /// ENTÃO ela deve estar salva no banco
//        let all = service.fetchAll()
//        XCTAssertEqual(all.count, 1)
//    }
//    
//    // MARK: Read
//    
//    ///(Buscar todas)
//    func testFetchAll() throws {
//        /// DADO QUE existem 2 localizações salvas
//        _ = service.create(latitude: 0.0, longitude: 0.0, altitude: 0.0, sculpture: Sculpture(name: "Test"))
//        _ = service.create(latitude: 0.0, longitude: 0.0, altitude: 0.0, sculpture: Sculpture(name: "Test"))
//
//        /// QUANDO eu busco todas
//        let all = service.fetchAll()
//
//        /// ENTÃO devo receber as 2 localizações
//        XCTAssertEqual(all.count, 2)
//    }
//    
//    ///(Buscar por ID)
//    func testFetchByID() throws {
//        /// DADO QUE existe uma localizações salva
//        let created = service.create(latitude: 0.0, longitude: 0.0, altitude: 0.0, sculpture: Sculpture(name: "Test"))
//        
//        /// QUANDO eu busco pela mesma pelo ID dela
//        let fetched = service.fetchByID(created.id)
//
//        /// ENTÃO ela deve ser encontrada e ter o mesmo ID
//        XCTAssertNotNil(fetched)
//        XCTAssertEqual(fetched?.id, created.id)
//    }
//    
//    //MARK: Delete
//    
//    func testDeleteLocalization() throws {
//        /// DADO QUE tenho uma escultura salva
//        let localization = service.create(latitude: 0.0, longitude: 0.0, altitude: 0.0, sculpture: Sculpture(name: "Test"))
//
//        /// QUANDO eu a deleto
//        service.delete(localization)
//
//        /// ENTÃO ela não deve mais existir no banco
//        let all = service.fetchAll()
//        XCTAssertEqual(all.count, 0)
//    }
//    
//    
//}
