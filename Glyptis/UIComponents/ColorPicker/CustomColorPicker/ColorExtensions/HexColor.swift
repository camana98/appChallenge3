//
//  HexColor.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 27/11/25.
//

import SwiftUI

struct HexColor: Identifiable {
    let id: Int
    let color: Color
    
    init(id: Int, color: Color) {
        self.id = id
        self.color = color
    }
}
