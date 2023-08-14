//
//  Date+Extension.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 28.06.2023.
//

import Foundation

extension Date {
    func dateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayNumber() -> Int? {
        return Calendar.current.dateComponents([.day, .month, .year], from: self).day
    }
    
    func onlyDate() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
