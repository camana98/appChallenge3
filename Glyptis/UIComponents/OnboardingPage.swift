//
//  OnboardingPage.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 08/12/25.
//

import SwiftUI

// MARK: - Modelo de Dados
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String?
    let isSystemIcon: Bool
}

// MARK: - View Principal do Onboarding
struct OnboardingView: View {
    @Binding var isPresented: Bool
    
    @State private var currentPage = 0
    
    // MARK: - Dados das Páginas
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Bem-vindo ao Glyptis",
            description: "Descubra uma nova forma de criar esculturas digitais e espalhar arte pelo mundo através da Realidade Aumentada.",
            iconName: "hand.wave.fill",
            isSystemIcon: true
        ),
        OnboardingPage(
            title: "Crie no Canvas",
            description: "Use ferramentas intuitivas para esculpir, pintar e modelar suas obras. Dê vida à sua imaginação cubo a cubo.",
            iconName: "paintbrush.pointed.fill",
            isSystemIcon: true
        ),
        OnboardingPage(
            title: "Explore o Museu",
            description: "Guarde suas criações em seu museu pessoal. Revise, edite ou admire suas esculturas a qualquer momento.",
            iconName: "building.columns.fill",
            isSystemIcon: true
        ),
        OnboardingPage(
            title: "Arte no Mundo Real",
            description: "Use a câmera para posicionar suas esculturas em superfícies reais. Transforme qualquer lugar em uma galeria.",
            iconName: "arkit",
            isSystemIcon: true
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
                .onTapGesture {
                    closeOnboarding()
                }
            
            VStack(spacing: 0) {
                
                /// Botão Pular (Topo Direita)
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Pular") {
                            closeOnboarding()
                        }
                        .font(.custom("NotoSans-Medium", size: 16))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    } else {
                        Color.clear
                            .frame(height: 44)
                            .padding(.top, 20)
                    }
                }
                
                /// Área do Carrossel
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 400)
                
                VStack(spacing: 20) {
                    
                    /// Bolinhas indicadoras
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(), value: currentPage)
                        }
                    }
                    
                    /// Botão Ação
                    Button {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            // Última página: fecha o componente
                            closeOnboarding()
                        }
                    } label: {
                        Text(currentPage == pages.count - 1 ? "Começar a Criar" : "Próximo")
                            .font(.custom("NotoSans-Medium", size: 18))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
            }
            // Card background com bordas arredondadas (incluindo inferiores)
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .light) // Ou .dark, conforme sua preferência
            }
            .padding(.horizontal, 20)
            .shadow(radius: 20)
        }
        .transition(.opacity)
    }
    
    // Função auxiliar para fechar com animação
    private func closeOnboarding() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - Subview (Mantida igual)
struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            
            /// Ícone
            if let icon = page.iconName {
                if page.isSystemIcon {
                    Image(systemName: icon)
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .padding(.bottom, 10)
                } else {
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .padding(.bottom, 10)
                }
            }
            
            /// Título
            Text(page.title)
                .font(.custom("Angle Square DEMO", size: 28))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
            
            /// Descrição
            Text(page.description)
                .font(.custom("NotoSans-Medium", size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 30)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}
