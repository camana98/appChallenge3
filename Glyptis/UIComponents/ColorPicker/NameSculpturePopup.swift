//
//  SculptureNamingPopup.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

import SwiftUI

struct NameSculpturePopup: View {
    @Binding var sculptureName: String
    var onSave: () -> Void
    var onCancel: () -> Void
    @FocusState private var isUsernameFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Primeiro fecha o teclado
                    if isUsernameFocused {
                        isUsernameFocused = false
                    } else {
                        // Se o teclado já não está ativo, fecha o popup imediatamente
                        onCancel()
                    }
                }
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Nomeie sua escultura")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                Text("Para salvar sua escultura no museu, defina um nome para ela.\n\nObs: A posição da escultura no museu será a mesma do canvas.")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.black)
                
                TextField("", text: $sculptureName)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(26)
                    .foregroundColor(.black)
                    .accessibilityIdentifier("SculptureNameTextField")
                    .focused($isUsernameFocused)
                
                Button(action: onSave) {
                    Text("Salvar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("customBlue").opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(100)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("ConfirmSaveButton")
                
            }
            .padding()
            .background(Color.white.opacity(0.6))
            .cornerRadius(32)
            .shadow(radius: 10)
            .frame(maxWidth: 350)
        }
        .onAppear {
            isUsernameFocused = true
        }
    }
}

#Preview {
    NameSculpturePopup(sculptureName: Binding.constant("oi"), onSave: {}, onCancel: {})
}
