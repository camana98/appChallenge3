//
//  MuseuGridListView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 26/11/25.
//

import SwiftUI

struct MuseuGridListView: View {
    
    @State var vm: MuseuGridViewModelProtocol

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
                        
                    }
                    .frame(width: 75,height: 75)
                    .scaledToFill()
                }
                .padding(.top)
                
                
                ScrollView {
                    LazyVGrid(columns: vm.columns, spacing: 13){
                        ForEach(vm.filteredSculptures) { escultura in
                            GridSculptureComponent(sculpture: escultura)
                                .contextMenu {
                                    
                                    Button {
                                        vm.edit(s: escultura)
                                    } label: {
                                        Label("Editar", systemImage: "pencil")
                                    }
                                    
                                    Button {
                                        vm.anchor(s: escultura)
                                    } label: {
                                        Label("Ancorar", systemImage: "pin")
                                    }
                                    
                                    Button(role: .destructive) {
                                        vm.delete(s: escultura)
                                    } label: {
                                        Label("Deletar", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(
                Rectangle()
                    .foregroundStyle(.foregroundMuseu)
                    .ignoresSafeArea()
            )
            .searchable(text:
                            $vm.searchText, isPresented: $vm.showSearch)
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            vm.fetchData()
        }
    }
}




