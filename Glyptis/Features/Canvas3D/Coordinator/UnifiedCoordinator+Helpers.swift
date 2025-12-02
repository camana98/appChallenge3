//
//  UnifiedCoordinator+Helpers.swift
//  Glyptis
//
//  Created by Guilherme Ghise Rossoni on 26/11/25.
//

extension UnifiedCoordinator {

    // MARK: - Parse helpers
    
    // Parseia nomes baseados na grid "base_x_z"
    func parseBaseName(_ name: String) -> (x: Int, z: Int)? {
        let parts = name.split(separator: "_")
        guard parts.count == 3, parts[0] == "base",
              let x = Int(parts[1]), let z = Int(parts[2])
        else { return nil }
        return (x, z)
    }

    // Parseia nomes de células "cell_x_z_layer"
    func parseCellName(_ name: String) -> (x: Int, z: Int, layer: Int)? {
        let parts = name.split(separator: "_")
        guard parts.count == 4, parts[0] == "cell",
              let x = Int(parts[1]), let z = Int(parts[2]), let layer = Int(parts[3])
        else { return nil }
        return (x, z, layer)
    }
    
    
}
