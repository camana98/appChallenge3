//
//  CameraHelpPopup.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 09/12/25.
//

import SwiftUI

struct CameraHelpPopup: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
                .onTapGesture { withAnimation { isPresented = false } }
            
            VStack(spacing: 24) {
                Text("Como usar o Modo AR")
                    .font(.custom("NotoSans-Bold", size: 22))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 16) {
                    instructionRow(icon: "lightbulb.max.fill", title: "Prepare o Ambiente", text: "Escaneie um local bem iluminado movendo a câmera lentamente.")
                    instructionRow(icon: "plus.square.fill.on.square.fill", title: "Adicionar Escultura", text: "Vá ao Museu, selecione uma obra e clique em 'Ancorar'.")
                    instructionRow(icon: "eye.fill", title: "Visualizar", text: "Escaneie a área para reencontrar esculturas já ancoradas.")
                    instructionRow(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "Ajustar Posição", text: "Arraste para mover no chão. Toque para ajustar a altura e rotacionar.")
                    instructionRow(icon: "trash.fill", title: "Remover", text: "Segure pressionado na escultura para deletar.")
                }
                
                Button { withAnimation { isPresented = false } } label: {
                    Text("Entendi")
                        .font(.custom("NotoSans-Bold", size: 16))
                        .foregroundStyle(.black)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 10)
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(20)
            .shadow(radius: 10)
        }
    }
    
    func instructionRow(icon: String, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 24)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.custom("NotoSans-Bold", size: 16)).foregroundStyle(.white)
                Text(text).font(.custom("NotoSans-Regular", size: 14)).foregroundStyle(.white.opacity(0.9)).fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
