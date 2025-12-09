//
//  MuseuGridViewModelProtocol.swift
//  Glyptis
//
//  Created by Vicenzo Másera on 27/11/25.
//

import Foundation
import SwiftUI

protocol MuseuGridViewModelProtocol {
    var showSearch: Bool { get set }
    var searchText: String { get set }
    var filteredSculptures: [Sculpture] { get }
    var sortOptions: SnapshotSortOption { get set }
    
    var sculptures: [Sculpture] { get set }
    
    var columns: [GridItem] { get }
    
    func delete(s: Sculpture) -> Void
    func edit(s: Sculpture)  -> Void
    func anchor(s: Sculpture)  -> Void
    func fetchData() -> Void
    func getSnapshot(s: Sculpture) -> UIImage
}
