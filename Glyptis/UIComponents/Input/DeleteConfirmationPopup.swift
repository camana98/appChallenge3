import SwiftUI

struct DeleteConfirmationPopup: View {
    var sculptureName: String
    var onConfirm: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // Fundo escurecido
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            VStack(alignment: .leading, spacing: 18) {
                // Título
                Text("Tem certeza que deseja deletar sua escultura \"\(sculptureName)\"?")
                    .font(Fonts.title2) // aqui você pode trocar pra Fonts.title se quiser
                    .foregroundStyle(.noite)
                    .multilineTextAlignment(.leading)
//                    .fixedSize(horizontal: false, vertical: true)
                
                // Mensagem
                Text("Uma vez deletada, não poderá ser recuperada no museu.")
                    .font(.subheadline)
                    .foregroundStyle(.acinzentado)
                    .multilineTextAlignment(.leading)
//                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(spacing: 10) {
                    // Botão "Sim, desejo deletar" – pill vermelha
                    Button(action: {
                        onConfirm()
                    }) {
                        Text("Sim, desejo deletar")
                            .font(.headline) // customiza aqui se quiser
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.06)) // fundo da pill
                    )
                    .foregroundStyle(Color.red)
                    .accessibilityIdentifier("ConfirmDeleteButton")
                    
                    // Botão "Não, desejo manter" – pill neutra
                    Button(action: {
                        onCancel()
                    }) {
                        Text("Não, desejo manter")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    .foregroundStyle(Color.white)
                    .accessibilityIdentifier("CancelDeleteButton")
                }
            }
            .padding(24)
            .background(.ultraThinMaterial) // efeito vidro
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .shadow(color: .black.opacity(0.35), radius: 30, x: 0, y: 20)
            .frame(maxWidth: 360)
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    DeleteConfirmationPopup(
        sculptureName: "ghhhh",
        onConfirm: {},
        onCancel: {}
    )
}
