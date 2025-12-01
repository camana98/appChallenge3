//
//  SimpleCubeIcon.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI

struct SimpleCubeIcon: View {
    let assetName: String
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
        }
        .buttonStyle(.plain)
    }
}
