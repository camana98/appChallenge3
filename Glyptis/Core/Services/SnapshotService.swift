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
}


