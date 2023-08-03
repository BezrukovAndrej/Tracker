//
//  WeekDaysMarshalling.swift
//  Tracker
//
//  Created by Andrey Bezrukov on 31.07.2023.
//

import Foundation

final class WeekDaysMarshalling {
    
    func convertWeekDaysToString(_ days: [WeekDay]) -> String {
        let shedule = days.map{ $0.rawValue + " "}.joined()
        return shedule
    }
    
    func convertStringToWeekDays(_ string: String?) -> [WeekDay] {
        guard let sheduleStringArray = string?.components(separatedBy: [" "]) else { return []}
        let sheduleArray = sheduleStringArray.compactMap{ WeekDay(rawValue: $0) }
        return sheduleArray
    }
}
