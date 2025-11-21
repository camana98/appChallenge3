//
//  Localization.swift
//  appChallenge3
//
//  Created by Vicenzo Másera on 18/11/25.
//
import SwiftData
import Foundation

@Model
final class Localization {
    var id: UUID
    var createdAt: Date
    
    var latitude: Double
    var longitude: Double
    var altitude: Double
    
    var sculpture: Sculpture?
    
    var contributors: [Author]?
    
    init(latitude: Double, longitude: Double, altitude: Double) {
        self.id = UUID()
        self.createdAt = Date()
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
}
