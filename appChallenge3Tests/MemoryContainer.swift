//
//  File.swift
//  appChallenge3Tests
//
//  Created by Pablo Garcia-Dev on 21/11/25.
//
//  Criado para testes in-memory usando SwiftData
//
//import Foundation
//import SwiftData
//
//enum MemoryContainer {
//
//    /// Cria um ModelContainer em memória para testes
//    static func makeInMemoryContainer() throws -> ModelContainer {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//
//        let container = try ModelContainer(
//            for: Author.self,
//            configurations: config
//        )
//
//        return container
//    }
//}

import SwiftData
@testable import appChallenge3

enum MemoryContainer {

    static func makeInMemoryContainer() throws -> ModelContainer {

        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)

        return try ModelContainer(
            for: Author.self,
                 Sculpture.self,
                 Localization.self,
            configurations: configuration
        )
    }
}




