//
//  Tracker.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let text: String
    let emoji: String
    let color: UIColor
    let schedule: [WeekDay]
}
