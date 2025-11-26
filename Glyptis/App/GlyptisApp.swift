//
//  GlyptisApp.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 19/11/25.
//

import SwiftUI
import SwiftData

@main
struct GlyptisApp: App {
    var body: some Scene {
        WindowGroup {
            ARCameraView()
        }
        .modelContainer(for: [
            Author.self,
            Cube.self,
            Localization.self,
            Sculpture.self,
        ])
    }
}
