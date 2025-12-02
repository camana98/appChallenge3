//
//  SnapshotBrowserService.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 02/12/25.
//

import Foundation
internal import UIKit

struct SnapshotBrowserService {

    static func listSnapshots() -> [URL] {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let files = (try? FileManager.default.contentsOfDirectory(
            at: dir,
            includingPropertiesForKeys: nil
        )) ?? []

        return files.filter { $0.pathExtension == "png" }
    }

    static func loadImage(from url: URL) -> UIImage? {
        UIImage(contentsOfFile: url.path)
    }
}

