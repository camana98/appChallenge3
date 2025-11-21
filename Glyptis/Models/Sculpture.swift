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
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var name: String = ""
    
    @Relationship(deleteRule: .cascade, inverse: \Localization.sculpture)
    var localization: Localization?
    
    var author: Author?
    
    @Relationship(deleteRule: .cascade, inverse: \Cube.sculpture)
    var cubes: [Cube]?
    
    init(name: String, localization: Localization? = nil, author: Author? = nil) {
        self.id = UUID()
        self.createdAt = Date()
        self.name = name
        self.localization = localization
        self.author = author
    }
}
