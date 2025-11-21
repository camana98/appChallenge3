//
//  ViewModelAuthorTests.swift
//  appChallenge3Tests
//
//  Created by Pablo Garcia-Dev on 21/11/25.
//

//import XCTest
//import SwiftData
//@testable import appChallenge3
//
//@MainActor
//final class ViewModelAuthorTests: XCTestCase {
//    
//    var container: ModelContainer!
//    var context: ModelContext!
//    var viewModel: ViewModelAuthor!
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}


//
//  ViewModelAuthorTests.swift
//  appChallenge3Tests
//

import XCTest
import SwiftData
@testable import appChallenge3

@MainActor
final class ViewModelAuthorTests: XCTestCase {

    var container: ModelContainer!
    var context: ModelContext!
    var viewModel: ViewModelAuthor!

    // MARK: - Setup
    override func setUp() {
        super.setUp()

        // Cria o banco em memória via arquivo separado
        container = try! MemoryContainer.makeInMemoryContainer()
        context = container.mainContext

        // Cria a ViewModel com o contexto de testes
        viewModel = ViewModelAuthor(context: context)
    }

    override func tearDown() {
        container = nil
        context = nil
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Test Create
    func testCreateAuthor() {
        let initialCount = viewModel.authors.count

        viewModel.createAuthor(name: "Pablo", appleUserID: "123")

        XCTAssertEqual(viewModel.authors.count, initialCount + 1)
        XCTAssertEqual(viewModel.authors.first?.name, "Pablo")
        XCTAssertEqual(viewModel.authors.first?.appleUserID, "123")
    }

    // MARK: - Test Read
    func testFetchAuthors() {
        let author1 = Author(name: "João", appleUserID: "001")
        let author2 = Author(name: "Maria", appleUserID: "002")

        context.insert(author1)
        context.insert(author2)
        try! context.save()

        viewModel.fetchAuthors()

        XCTAssertEqual(viewModel.authors.count, 2)
    }

    // MARK: - Test Delete
    func testDeleteAuthor() {
        viewModel.createAuthor(name: "Autor Teste", appleUserID: "999")

        guard let author = viewModel.authors.first else {
            XCTFail("O autor não foi criado corretamente")
            return
        }

        viewModel.deleteAuthor(author)

        XCTAssertTrue(viewModel.authors.isEmpty)
    }

    // MARK: - Test Sorting
    func testSortingByCreatedAtDescending() {
        let older = Author(name: "Antigo", appleUserID: "old")
        older.createdAt = Date(timeIntervalSince1970: 0)

        let newer = Author(name: "Novo", appleUserID: "new")
        newer.createdAt = Date()

        context.insert(older)
        context.insert(newer)
        try! context.save()

        viewModel.fetchAuthors()

        XCTAssertEqual(viewModel.authors.first?.name, "Novo")
        XCTAssertEqual(viewModel.authors.last?.name, "Antigo")
    }
}
