//
//  Cube.swift
//  appChallenge3
//
//  Created by Vicenzo Másera on 18/11/25.
//
import SwiftData
import Foundation

@Model
final class Cube {
    var id: UUID
    
    var locationX: Float
    var locationY: Float
    var locationZ: Float
    
    var colorR: Float // 0.0 - 1.0
    var colorG: Float
    var colorB: Float
    var colorA: Float?
    
    var sculpture: Sculpture?
    
    init(sculpture: Sculpture, x: Float, y: Float, z: Float, r: Float, g: Float, b: Float) {
        self.id = UUID()
        self.sculpture = sculpture
        self.locationX = x
        self.locationY = y
        self.locationZ = z
        self.colorR = r
        self.colorG = g
        self.colorB = b
    }
}
