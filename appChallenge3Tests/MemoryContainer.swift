//
//  File.swift
//  appChallenge3Tests
//
//  Created by Pablo Garcia-Dev on 21/11/25.
//
//  Criado para testes in-memory usando SwiftData
//

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




