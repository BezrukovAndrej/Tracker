//
//  Pages.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 08.08.2023.
//

import Foundation

enum Pages: CaseIterable {
    case pageOne
    case pageTwo
    
    var title: String {
        switch self {
        case .pageOne:
            return "Отслеживайте только то, что хотите"
        case .pageTwo:
            return "Даже если это \nне литры воды и йога"
        }
    }
    
    var index: Int {
        switch self {
        case .pageOne:
            return 0
        case .pageTwo:
            return 1
        }
    }
}
