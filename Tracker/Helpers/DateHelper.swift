//
//  DateHelper.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 02.08.2023.
//

import Foundation

class DateHelper {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}
