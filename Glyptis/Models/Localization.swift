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
    var id: UUID = UUID()
    var createdAt: Date = Date()
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var altitude: Double = 0.0
    
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
