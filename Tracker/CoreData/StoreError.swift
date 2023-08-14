//
//  StoreError.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 31.07.2023.
//

import Foundation

enum StoreError: Error {
    case decodeCategoryStoreError
    case decodeTrackerStoreError
    case decodeRecordStoreError
    case deleteError
    case pinError
    case updateError
    case getRecordError
    case saveRecordError
    case deleteRecordError
    case decodeError
    case fetchCategoryError
}
