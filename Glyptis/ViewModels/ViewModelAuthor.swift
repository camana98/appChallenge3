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
    
    @Published var authors: [Author] = []
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        fetchAuthors()
    }
    
    //MARK: - Create Authors
    
    func createAuthor(name: String, appleUserID: String) {
        let descriptor = FetchDescriptor<Author>(
            predicate: #Predicate { $0.appleUserID == appleUserID }
        )
        
        do {
            if let existing = try context.fetch(descriptor).first {
                updateAuthor(existing, name: name)
                return
            }
            
            let newAuthor = Author(name: name, appleUserID: appleUserID)
            context.insert(newAuthor)
            

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
    
    //MARK: - Update Authors
    func updateAuthor(_ author: Author, name: String) {
        author.name = name
        author.createdAt = Date()
        
        do {
            try context.save()
            fetchAuthors()
        } catch {
            print("Erro ao atualizar autor: \(error)")
        }
    }

    //MARK: - Delete Authors
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

