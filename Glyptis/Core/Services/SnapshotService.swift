//
//  SnapshotService.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 27/11/25.
//

internal import UIKit
internal import RealityKit
internal import ARKit

struct SnapshotService {

    // MARK: - SNAPSHOT DO ARVIEW
    static func takeSnapshot(from arView: ARView, cameraCoordinator: UnifiedCoordinator?, completion: @escaping (UIImage?) -> Void) {
    
        cameraCoordinator?.updateCameraPosition(animated: true)
        
        // CRÍTICO: Garante que o ARView do Canvas não tenha nenhuma sessão AR ativa
        // Isso evita que a snapshot capture o feed da câmera AR
        if arView.session.configuration != nil {
            arView.session.pause()
        }
        
        // Garante que o ARView está em modo não-AR e sem sessão
        // Força a limpeza de qualquer estado relacionado à câmera
        arView.environment.background = .color(.clear)
        
        // CRÍTICO: Força a renderização do frame atual antes de capturar
        // Isso garante que apenas o conteúdo 3D seja capturado, não o feed da câmera
        arView.setNeedsDisplay()
        
        // Aguarda um frame para garantir que tudo seja renderizado corretamente
        // e que a sessão AR esteja completamente pausada
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            // Usa snapshot assíncrono, mas garante que a sessão AR esteja pausada
            // Isso evita que capture o feed da câmera AR
            arView.snapshot(saveToHDR: false) { image in
                guard let image = image else {
                    completion(nil)
                    return
                }
                
                // Processa a imagem para remover o fundo preto e garantir transparência
                let processedImage = processImageForTransparency(image)
                completion(processedImage)
            }
        }
    }
    
    // MARK: - Processa imagem para remover fundo preto e garantir transparência
    private static func processImageForTransparency(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return image
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelData = context.data else {
            return image
        }
        
        let pixels = pixelData.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        
        // Remove apenas pixels completamente pretos (RGB = 0,0,0) tornando-os transparentes
        // Isso preserva os cubos mesmo que sejam escuros, mas remove o fundo preto sólido
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = (y * width + x) * bytesPerPixel
                let r = pixels[pixelIndex]
                let g = pixels[pixelIndex + 1]
                let b = pixels[pixelIndex + 2]
                
                // Se o pixel for completamente preto (ou muito próximo), torna transparente
                // Threshold baixo para remover apenas fundo preto sólido
                if r < 5 && g < 5 && b < 5 {
                    pixels[pixelIndex + 3] = 0 // Torna transparente
                }
            }
        }
        
        guard let processedCGImage = context.makeImage() else {
            return image
        }
        
        return UIImage(cgImage: processedCGImage)
    }

    // MARK: - SALVAR IMAGEM + COMPLETION PARA ALERTA
    static func saveSnapshot(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let data = image.pngData() else {
            completion(false)
            return
        }

        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("snapshot-\(UUID().uuidString).png")

        do {
            try data.write(to: url)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    //Código do Igor Skriva
    
    static func saveDrawing(data: Data) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documentsDirectory.appendingPathComponent("snapshot").appendingPathExtension("png")
//        print(url)
        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print("Unable to write in new file. \(error)")
        }
    }
    
    
}


