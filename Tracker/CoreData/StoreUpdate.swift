//
//  StoreUpdate.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 03.08.2023.
//

import Foundation

struct StoreUpdate {
    
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

