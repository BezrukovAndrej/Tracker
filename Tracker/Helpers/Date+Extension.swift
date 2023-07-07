//
//  Date+Extension.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayNumber() -> Int? {
        return Calendar.current.dateComponents([.day, .month, .year], from: self).day
    }
}
