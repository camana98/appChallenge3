//
//  SnapshotService.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 27/11/25.
//

internal import UIKit
internal import RealityKit

struct SnapshotService {

    // MARK: - SNAPSHOT DO ARVIEW
    static func takeSnapshot(from arView: ARView, completion: @escaping (UIImage?) -> Void) {
        arView.snapshot(saveToHDR: false) { image in
            completion(image)
        }
    }
    
    // MARK: - SALVAR IMAGEM
    static func saveSnapshot(_ image: UIImage) -> URL? {
        guard let data = image.pngData() else { return nil }

        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("snapshot-\(UUID().uuidString).png")

        do {
            try data.write(to: url)
            print("Snapshot salvo em:", url)
            return url
        } catch {
            print("Erro ao salvar snapshot:", error)
            return nil
        }
    }
}

