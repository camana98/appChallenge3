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
                    onCancel()
                }
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Nomeie sua escultura")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                Text("Para salvar sua escultura no museu, defina um nome para ela.")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.black)
                
                TextField("Escreva aqui", text: $sculptureName)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(26)
                    .foregroundColor(.black)
                    .accessibilityIdentifier("SculptureNameTextField")
                    .focused($isUsernameFocused)
                
                Button("Salvar") {
                    onSave()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("customBlue").opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(100)
                .accessibilityIdentifier("ConfirmSaveButton")
                .onTapGesture {
                    onSave()
                }
                
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
