//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import Foundation

struct TrackerCategory: Equatable {
    let id: UUID
    let title: String
    
    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
