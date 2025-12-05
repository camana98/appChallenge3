//
//  DeleteConfirmationPopup.swift
//  Glyptis
//
//  Created by Auto on 05/12/25.
//

import SwiftUI

struct DeleteConfirmationPopup: View {
    var sculptureName: String
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onCancel()
                }
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Deletar escultura?")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                Text("Tem certeza que deseja deletar \"\(sculptureName)\"? Esta ação não pode ser desfeita.")
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.black)
                
                HStack(spacing: 12) {
                    Button("Cancelar") {
                        onCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .cornerRadius(100)
                    .accessibilityIdentifier("CancelDeleteButton")
                    
                    Button("Deletar") {
                        onConfirm()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("customRed").opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(100)
                    .accessibilityIdentifier("ConfirmDeleteButton")
                }
                
            }
            .padding()
            .background(Color.white.opacity(0.6))
            .cornerRadius(32)
            .shadow(radius: 10)
            .frame(maxWidth: 350)
        }
    }
}

