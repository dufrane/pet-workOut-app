//
//  Date + Extensions.swift
//  workOut
//
//  Created by Dmytro Vasylenko on 25.09.2022.
//

import Foundation

extension Date {
    
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) ?? Date()
        return localDate
    }
    
    func getWeekArray() -> [[String]] {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "EEEEEE"
        
        var weekArray : [[String]] = [[],[]]
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC") ?? .current
        
        for index in -6...0 {
            let date = calendar.date(byAdding: .day, value: index, to: self) ?? Date()
            let day = calendar.component(.day, from: date.localDate())
            weekArray[1].append("\(day)")
            let weekday = formatter.string(from: date.localDate())
            weekArray[0].append(weekday)
        }
        return weekArray
    }
    
    func startEndDate() -> (Date, Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let dateStart = formatter.date(from: "\(year)/\(month)/\(day)") ?? Date()
        
        let local = dateStart.localDate()
        let dateEnd: Date = {
            let components = DateComponents(day: 1 )
            return calendar.date(byAdding: components, to: local) ?? Date()
        }()

        return(local, dateEnd)
    }
    
    func getWeekDayNumber() -> Int {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: self)
        return weekDay
    }
    
    func offsetDays(days: Int) -> Date {
        let offsetDate = Calendar.current.date(byAdding: .day, value: -days, to: self) ?? Date()
        return offsetDate
    }
    
    func offsetMonth(month: Int) -> Date {
        let offsetDate = Calendar.current.date(byAdding: .month, value: -month, to: self) ?? Date()
        return offsetDate
    }
}
