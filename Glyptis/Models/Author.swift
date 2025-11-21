//
//  ModelExample.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//
import SwiftData
import Foundation

@Model
final class Author {
    var id: UUID
    var createdAt: Date
    var name: String
    var appleUserID: String?
    
    var createdSculptures: [Sculpture]?
    
    var contribuitedLocations: [Localization]?
    
    init(name: String, appleUserID: String? = nil) {
        self.id = UUID()
        self.name = name
        self.appleUserID = appleUserID
        self.createdAt = Date()
    }
}
