//
//  URL+Metadata.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 04/12/25.
//

import Foundation

extension URL {
    var cretionDate: Date? {
        try? resourceValues(forKeys: [.creationDateKey]).creationDate
    }
}
