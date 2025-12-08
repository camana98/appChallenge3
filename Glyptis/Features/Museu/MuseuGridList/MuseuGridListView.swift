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
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Minhas Esculturas")
                            .font(.custom("AngleSquareDEMO", size: 28))
                            .foregroundColor(.primary)
                        
                        Text("Filtro: \(vm.sortOptions.rawValue)")
                            .font(.custom("NotoSans-Regular", size: 14))
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Menu {
                        ForEach(SnapshotSortOption.allCases) { option in
                            Button(option.rawValue) {
                                vm.sortOptions = option
                                vm.fetchData()
                            }
                        }
                    } label: {
                        SimpleCubeIcon(
                            assetName: "filterCube",
                            width: 44,
                            height: 46
                        ) {}
                    }
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: vm.columns, spacing: 13){
                        ForEach(vm.filteredSculptures) { escultura in
                            VStack {
                                ZStack(alignment: .center) {
                                    Image(.bezeled)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    Image(uiImage: vm.getSnapshot(s: escultura))
                                        .resizable()
                                        .scaledToFit()
                                        .offset(y: 16)
                                }
                                
                                Text(escultura.name)
                                    .font(Fonts.notoSemi)
                                
                            }
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
                            .frame(width: 108, height: 130)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background(.ultraThinMaterial.opacity(0.5))
            .searchable(text:$vm.searchText, isPresented: $vm.showSearch)
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            vm.fetchData()
        }
    }
}




