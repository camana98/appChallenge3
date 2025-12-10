//
//  ComingSoonPopup.swift
//  Glyptis
//
//  Created by Eduardo Camana on 09/12/25.
//

import SwiftUI

struct ComingSoonPopup: View {
    var onClose: () -> Void
    var onOpenInstagram: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    onClose()
                }
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Em breve!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Esta funcionalidade estará disponível nas próximas atualizações do app. Acompanhe nossas novidades pelo Instagram!")
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.black)
                    
                    Button {
                        onOpenInstagram()
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16))
                            Text("Seguir no Instagram")
                                .font(.custom("NotoSans-Medium", size: 16))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("customBlue").opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(100)
                    }
                    
                    Button("Fechar") {
                        onClose()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(100)
                    
                }
                .padding(24)
                .background(Color.white.opacity(0.95))
                .cornerRadius(32)
                .shadow(radius: 20)
                .frame(maxWidth: 350)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ComingSoonPopup(
        onClose: {},
        onOpenInstagram: {}
    )
}

