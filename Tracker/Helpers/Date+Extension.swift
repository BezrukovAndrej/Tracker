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
    
    func onlyDate() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: components) else { return Date() }
        return date
    }
}
