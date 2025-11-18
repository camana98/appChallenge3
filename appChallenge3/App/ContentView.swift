//
//  ContentView.swift
//  appChallenge3
//
//  Created by Eduardo Camana on 04/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ViewExample()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [], inMemory: true)
}
