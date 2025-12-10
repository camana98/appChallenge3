//
//  MuseuView.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 25/11/25.
//

import Foundation
import SwiftUI
internal import RealityKit
import SwiftData
import AVFoundation
internal import ARKit

struct MuseuView: View {
    
    @State var vm: MuseuViewModelProtocol
    @State private var selectedSculptureID: Sculpture.ID?
    
    @State private var showGridListMuseum: Bool = false
    @State private var sculptureToDelete: Sculpture?
    @State private var isDeleting: Bool = false
    @State private var deletingSculptureID: Sculpture.ID?
    @State private var showComingSoonPopup: Bool = false
    
    // Onboarding
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var showOnboarding: Bool = false
    
    var onBackClicked: () -> Void
    var onEditSculpture: ((Sculpture) -> Void)?
    var onAnchorSculpture: ((Sculpture) -> Void)?
    var onOpenCamera: (() -> Void)? = nil
    var onOpenCanvas: (() -> Void)? = nil
    
    @Query private var sculptures: [Sculpture]
    
    var activeSculpture: Sculpture? {
        if let id = selectedSculptureID, let sculpture = vm.sculptures.first(where: { $0.id == id }) {
            return sculpture
        }
        return vm.sculptures.first
    }
    
    var body: some View {
        ZStack {
            Image(.backgroundMuseu)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 9.0)
            
            VStack {
                // Header
                HStack {
                    Color.clear.frame(width: 55, height: 55)
                    Spacer()
                    Text("Museu")
                        .font(Fonts.title)
                        .foregroundStyle(.customWhite)
                    Spacer()
                    if !vm.sculptures.isEmpty {
                        SimpleCubeIcon(assetName: "gridCube", width: 55, height: 55) {
                            showGridListMuseum.toggle()
                        }
                    } else {
                        Color.clear.frame(width: 55, height: 55)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 45)
                
                Spacer()
                
                if vm.sculptures.isEmpty {
                    MuseuEmptyStateView(
                        onBackClicked: onBackClicked,
                        onSave: { withAnimation { vm.fetchData() } }
                    )
                } else {
                    // MARK: - Área Principal
                    ZStack(alignment: .bottom) {
                        
                        // 1. Carrossel de Esculturas
                        // Calculamos o índice da escultura selecionada para saber quem são os vizinhos
                        let selectedIndex = vm.sculptures.firstIndex(where: { $0.id == selectedSculptureID }) ?? 0
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                // Usamos enumerated() para ter acesso ao índice de cada item
                                ForEach(Array(vm.sculptures.enumerated()), id: \.element.id) { index, sculpture in
                                    ZStack(alignment: .bottom) {
                                        VStack(spacing: 0) {
                                            
                                            // --- LÓGICA DE TRANSIÇÃO SUAVE ---
                                            // Renderiza se for a escultura selecionada OU um vizinho imediato (+/- 1)
                                            // Isso permite que a animação comece ANTES de chegar no centro.
                                            let isNeighbor = abs(index - selectedIndex) <= 1
                                            
                                            if isNeighbor && deletingSculptureID != sculpture.id {
                                                
                                                FloatingSculpture3DContainer(sculpture: sculpture, isActive: true)
                                                    .frame(width: 300, height: 300)
                                                    .padding(.bottom, -40)
                                                    .zIndex(1)
                                                    // .scrollTransition controla a opacidade DURANTE o arrasto.
                                                    // phase.isIdentity = Centro (Opacidade 1)
                                                    // phase não identity = Lados (Opacidade diminui)
                                                    .scrollTransition { content, phase in
                                                        content
                                                            .opacity(phase.isIdentity ? 1.0 : 0.0) // Fade de 0 a 1 enquanto entra
                                                            .scaleEffect(phase.isIdentity ? 1.0 : 0.8) // Leve zoom in
                                                    }
                                                
                                            } else {
                                                // Espaço vazio para manter o layout, mas sem peso de renderização
                                                Color.clear
                                                    .frame(width: 300, height: 300)
                                                    .padding(.bottom, -40)
                                                    .zIndex(1)
                                            }
                                            
                                            Image(.colunaMuseu)
                                                .padding(.leading, 10)
                                        }
                                        // Transições da Coluna + Container
                                        .scrollTransition { content, phase in
                                            content
                                                .blur(radius: phase.isIdentity ? 0 : 2) // Blur no conjunto todo ao sair
                                                .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                                .brightness(phase.isIdentity ? 0 : -0.35)
                                                .offset(y: phase.isIdentity ? 0 : -90)
                                        }
                                        .opacity(deletingSculptureID == sculpture.id ? 0 : 1)
                                        .rotationEffect(.degrees(deletingSculptureID == sculpture.id ? -45 : 0))
                                        .scaleEffect(deletingSculptureID == sculpture.id ? 0.8 : 1.0)
                                        .offset(
                                            x: deletingSculptureID == sculpture.id ? 100 : 0,
                                            y: deletingSculptureID == sculpture.id ? UIScreen.main.bounds.height + 200 : 0
                                        )
                                        .animation(
                                            deletingSculptureID == sculpture.id ? .easeIn(duration: 0.9) : .default,
                                            value: deletingSculptureID
                                        )
                                    }
                                    .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 0)
                                    .frame(width: UIScreen.main.bounds.width * 0.7)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .scrollPosition(id: $selectedSculptureID)
                        .safeAreaPadding(.horizontal, (UIScreen.main.bounds.width * 0.15))
                        .padding(.bottom, 0)
                        
                        // 2. Menu de Botões Fixo
                        if let currentSculpture = activeSculpture {
                            MuseuButtonsComponent(
                                sculpture: currentSculpture,
                                vm: vm,
                                sculptureToDelete: $sculptureToDelete,
                                onOpenCamera: { onOpenCamera?() },
                                onOpenCanvas: { onOpenCanvas?() },
                                onAnchorSculpture: { s in onAnchorSculpture?(s) },
                                onShowComingSoon: { showComingSoonPopup = true }
                            )
                            .disabled(deletingSculptureID != nil)
                            .opacity(deletingSculptureID != nil ? 0.5 : 1.0)
                        }
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                }
            }
            
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding).zIndex(100)
            }
            if showComingSoonPopup {
                ComingSoonPopup(
                    onClose: { showComingSoonPopup = false },
                    onOpenInstagram: { openInstagram() }
                )
                .transition(.opacity)
                .zIndex(200)
            }
        }
        .sheet(isPresented: $showGridListMuseum) {
            MuseuGridListView(vm: MuseuGridViewModel(service: SwiftDataService.shared))
                .presentationDetents([.medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
        .onAppear {
            vm.fetchData()
            if selectedSculptureID == nil, let first = vm.sculptures.first {
                selectedSculptureID = first.id
            }
            if let onEdit = onEditSculpture {
                vm.setOnEditNavigation(onEdit)
            }
            if !hasSeenOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation { showOnboarding = true }
                }
            }
        }
        .alert(item: $sculptureToDelete) { sculpture in
            Alert(
                title: Text("Tem certeza que deseja deletar sua escultura \"\(sculpture.name)\"?"),
                message: Text("Uma vez deletada, não poderá ser recuperada no museu."),
                primaryButton: .destructive(Text("Sim, desejo deletar")) {
                    deletingSculptureID = sculpture.id
                    SoundManager.shared.playSound(named: "cleanCubes", volume: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                        vm.delete(s: sculpture)
                        deletingSculptureID = nil
                    }
                },
                secondaryButton: .cancel(Text("Não, desejo manter"))
            )
        }
    }
    
    private func openInstagram() {
        let instagramUsername = "app.glyptis"
        let instagramURL = URL(string: "instagram://user?username=\(instagramUsername)")!
        let instagramWebURL = URL(string: "https://www.instagram.com/\(instagramUsername)/")!
        
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL)
        } else {
            UIApplication.shared.open(instagramWebURL)
        }
        showComingSoonPopup = false
    }
}

// MARK: - Container com Animação
private struct FloatingSculpture3DContainer: View {
    let sculpture: Sculpture
    let isActive: Bool
    
    @State private var offsetY: CGFloat = 200
    
    var body: some View {
        Sculpture3DView(sculpture: sculpture)
            .offset(y: offsetY)
            .onAppear {
                if isActive { startFloating() }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue { startFloating() }
                else { stopFloating() }
            }
    }
    
    private func startFloating() {
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            offsetY = 220
        }
    }
    
    private func stopFloating() {
        withAnimation(.easeOut(duration: 0.3)) {
            offsetY = 180
        }
    }
}

// MARK: - View 3D Otimizada
struct Sculpture3DView: UIViewRepresentable {
    let sculpture: Sculpture

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        
        arView.backgroundColor = .clear
        arView.layer.isOpaque = false
        arView.environment.background = .color(.clear)
        
        // Configurações críticas para performance (sem perder a forma dos cubos)
        arView.renderOptions = [
            .disableGroundingShadows,
            .disableHDR,
            .disableMotionBlur,
            .disableDepthOfField,
            .disableFaceOcclusions,
            .disablePersonOcclusion
        ]
        
        let sceneAnchor = AnchorEntity(world: .zero)
        arView.scene.anchors.append(sceneAnchor)
        
        let light = DirectionalLight()
        light.light.intensity = 1500
        light.orientation = simd_quatf(angle: -.pi / 4, axis: [1, 0, 0])
        sceneAnchor.addChild(light)
        
        let rootEntity = Entity()
        sceneAnchor.addChild(rootEntity)
        
        if let cubes = sculpture.cubes {
            let cubeSize: Float = 0.05
            for cube in cubes {
                let color = UIColor(
                    red: CGFloat(cube.colorR),
                    green: CGFloat(cube.colorG),
                    blue: CGFloat(cube.colorB),
                    alpha: CGFloat(cube.colorA ?? 1)
                )
                
                let material = SimpleMaterial(color: color, isMetallic: false)
                let mesh = MeshResource.generateBox(size: cubeSize)
                let model = ModelEntity(mesh: mesh, materials: [material])
                
                model.position = SIMD3<Float>(cube.locationX, cube.locationY, cube.locationZ)
                rootEntity.addChild(model)
            }
        }
        
        rootEntity.orientation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0])
        
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 50
        let cameraPos: SIMD3<Float> = [0, 0.6, 1.4]
        camera.position = cameraPos
        camera.look(at: [0, 0.1, 0], from: cameraPos, relativeTo: nil)
        
        let cameraAnchor = AnchorEntity(world: .zero)
        cameraAnchor.addChild(camera)
        arView.scene.anchors.append(cameraAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) { }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
        uiView.scene.anchors.removeAll()
        uiView.removeFromSuperview()
    }
}
