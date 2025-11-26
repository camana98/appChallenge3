//
//  MuseuGridListView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 26/11/25.
//

import SwiftUI

struct MuseuGridListView: View {
    
    @State private var searchText = ""
    @State private var showSearch: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 11) {
                
                HStack() {
                    
                    VStack(alignment: .leading) {
                        Text("Minhas Esculturas")
                        
                        Text("Filtro: ")
                        
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    CubeButtonComponent(cubeStyle: .filters, cubeColor: .blue) {
                        print("filtros")
                    }
                    .frame(width: 75, height: 75)
                    .scaledToFill()
                }
                
                
                ScrollView {
                    Text("Grid de Esculturas...")
                        .padding()
                }
            }
            .background(
                Rectangle()
                    .foregroundStyle(.foregroundMuseu)
                    .ignoresSafeArea()
            )
            .searchable(text: $searchText, isPresented: $showSearch)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    MuseuGridListView()
}


