//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI

struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    
    var body: some View {
        ARViewContainer(coordinator: $coordinator)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ARCameraView()
}
