//
//  ARCameraView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 24/11/25.
//

import SwiftUI
import SwiftData


struct ARCameraView: View {
    
    @State var coordinator = ARViewCoordinator()
    
    // controla a abertura da tela de snapshots
    @State private var showSnapshots = false
    @Environment(\.modelContext) private var context
    
    // Closure para avisar quando abrir o Canvas
    var onOpenCanvas: () -> Void
    var onOpenMuseum: () -> Void
    
    var body: some View {
        ZStack {
            
            ARViewContainer(coordinator: $coordinator)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Button {
                    onOpenMuseum()
                } label: {
                    Text("Ir para Museu")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("GoToMuseumButton")

                
                Button {
                    onOpenCanvas()
                } label: {
                    Text("Ir para Canvas")
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("GoToCanvasButton")
                
                Button {
                    showSnapshots = true
                } label: {
                    Text("Ver Snapshots")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 12)
                .padding(.bottom, 50)
                .accessibilityIdentifier("GoToSnapShotsButton")
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showSnapshots) {
            SnapshotListView()
        }
    }
    
    private func printSavedSculptures() {
        do {
            let descriptor = FetchDescriptor<Sculpture>()
            let sculptures = try context.fetch(descriptor)

            print("=== ESCULTURAS SALVAS ===")

            if sculptures.isEmpty {
                print("Nenhuma escultura salva.")
            } else {
                for sculpture in sculptures {

                    // IMPRESSÃO CORRETA DO NOME
                    print("• Nome: \(sculpture.name)")
                    
                    // LOADING DA LISTA DE CUBOS
                    let cubes = sculpture.cubes ?? []
                    print("  Quantidade de cubos: \(cubes.count)")
                    
                    // IMPRIMIR AS POSIÇÕES
                    for cube in cubes {
                        print("    • Cube(x: \(cube.locationX), y: \(cube.locationY), z: \(cube.locationZ)) "
                              + "cor(r: \(cube.colorR), g: \(cube.colorG), b: \(cube.colorB), a: \(cube.colorA ?? 1))")
                    }

                    print("-------------------------")
                }
            }

            print("==========================")

        } catch {
            print("Erro ao carregar esculturas: \(error)")
        }
    }

}

#Preview {
    ARCameraView(onOpenCanvas: {}, onOpenMuseum: {})
}

