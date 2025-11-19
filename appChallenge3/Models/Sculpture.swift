//
//  Sculpture.swift
//  appChallenge3
//
//  Created by Vicenzo Másera on 18/11/25.
//
import SwiftData
import Foundation

@Model
final class Sculpture {
    var id: UUID
    var createdAt: Date
    var name: String
    
    var localization: Localization?
    
    var author: Author?
    
    var cubes: [Cube]?
    
    init(name: String, localization: Localization? = nil, author: Author? = nil) {
        self.id = UUID()
        self.createdAt = Date()
        self.name = name
        self.localization = localization
        self.author = author
    }
}
