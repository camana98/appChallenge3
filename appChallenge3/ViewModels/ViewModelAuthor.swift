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
//        fetchAuthors()
    }
    
    func createAuthor() {
        
    }
    
    func fetchAuthors() {
        
    }
    
}
