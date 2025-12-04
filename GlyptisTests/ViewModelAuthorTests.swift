////  ViewModelAuthorTests.swift
////  appChallenge3Tests
////
////  Created by Pablo Garcia-Dev on 21/11/25.
////
//
//import XCTest
//import SwiftData
//@testable import Glyptis
//
//@MainActor
//final class ViewModelAuthorTests: XCTestCase {
//
//    var container: ModelContainer!
//    var context: ModelContext!
//    var viewModel: ViewModelAuthor!
//
//    // MARK: - Setup
//    override func setUp() {
//        super.setUp()
//
//        // Cria o banco em memória via arquivo separado
//        container = try! MemoryContainer.makeInMemoryContainer()
//        context = container.mainContext
//
//        // Cria a ViewModel com o contexto de testes
//        viewModel = ViewModelAuthor(context: context)
//    }
//
//    override func tearDown() {
//        container = nil
//        context = nil
//        viewModel = nil
//
//        super.tearDown()
//    }
//
//    // MARK: - Test Create
//    func testCreateAuthor() {
//        let initialCount = viewModel.authors.count
//
//        viewModel.createAuthor(name: "Pablo", appleUserID: "123")
//
//        XCTAssertEqual(viewModel.authors.count, initialCount + 1)
//        XCTAssertEqual(viewModel.authors.first?.name, "Pablo")
//        XCTAssertEqual(viewModel.authors.first?.appleUserID, "123")
//    }
//
//    // MARK: - Test Read
//    func testFetchAuthors() {
//        let author1 = Author(name: "João", appleUserID: "001")
//        let author2 = Author(name: "Maria", appleUserID: "002")
//
//        context.insert(author1)
//        context.insert(author2)
//        try! context.save()
//
//        viewModel.fetchAuthors()
//
//        XCTAssertEqual(viewModel.authors.count, 2)
//    }
//
//    // MARK: - Test Delete
//    func testDeleteAuthor() {
//        viewModel.createAuthor(name: "Autor Teste", appleUserID: "999")
//
//        guard let author = viewModel.authors.first else {
//            XCTFail("O autor não foi criado corretamente")
//            return
//        }
//
//        viewModel.deleteAuthor(author)
//
//        XCTAssertTrue(viewModel.authors.isEmpty)
//    }
//
//    // MARK: - Test Sorting
//    func testSortingByCreatedAtDescending() {
//        let older = Author(name: "Antigo", appleUserID: "old")
//        older.createdAt = Date(timeIntervalSince1970: 0)
//
//        let newer = Author(name: "Novo", appleUserID: "new")
//        newer.createdAt = Date()
//
//        context.insert(older)
//        context.insert(newer)
//        try! context.save()
//
//        viewModel.fetchAuthors()
//
//        XCTAssertEqual(viewModel.authors.first?.name, "Novo")
//        XCTAssertEqual(viewModel.authors.last?.name, "Antigo")
//    }
//}
//
