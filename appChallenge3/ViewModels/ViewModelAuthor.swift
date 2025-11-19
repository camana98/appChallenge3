//
//  ViewModelAuthor.swift
//  appChallenge3
//
//  Created by Pablo Garcia-Dev on 19/11/25.
//

import Foundation
import SwiftUI
import Combine
import SwiftData

@MainActor
final class ViewModelAuthor: ObservableObject {
    var objectWillChange: ObservableObjectPublisher
    
    
    @Published var authors: [Author] = []
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.objectWillChange = .init()
        self.context = context
        fetchAuthors()
    }
    
    //MARK: - Create Authors
    
    func createAuthor(name: String, appleUserID: String) {
        let newAuthor = Author(name: name, appleUserID: appleUserID)
        context.insert(newAuthor)
        
        
        do {
            try context.save()
            fetchAuthors()
            
        } catch {
            print("Erro ao criar novo autor: \(error)")
        }
    }
    
    //MARK: - Read Authors
    func fetchAuthors() {
        let descriptor = FetchDescriptor<Author>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            authors = try context.fetch(descriptor)
        } catch {
            print("Erro ao buscar autores: \(error)")
        }
    }
    
    func deleteAuthor(_ author: Author) {
        context.delete(author)
        
        do {
            try context.save()
            fetchAuthors()
        } catch {
            print("Erro ao deletar autor: \(error)")
        }
    }
}
