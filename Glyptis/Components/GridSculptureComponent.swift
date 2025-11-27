//
//  GridSculptureComponent.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 27/11/25.
//

import SwiftUI

struct GridSculptureComponent: View {
    
    var sculpture: Sculpture
    
    var body: some View {
        VStack {
            ZStack {
                Image(.bezeled)
                    .scaledToFill()
                
            }
            
            Text("")
                .font(.custom, size: <#T##CGFloat#>))
            
        }
    }
}

#Preview {
    GridSculptureComponent()
}
