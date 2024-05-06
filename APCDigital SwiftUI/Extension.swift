//
//  Extension.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation

extension Date {
    func printStyleString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        dateFormatter.timeStyle = style
        dateFormatter.locale = .current
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

extension DateComponents {
    mutating func setTimeInDateComponents(hour: Int, minute: Int, second:Int, nanosecond: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.nanosecond = nanosecond
    }
}

extension Calendar {
    static func shortMonthSymbols(local: Locale) -> [String] {
        var calendar = Calendar.current
        calendar.locale = local
        return calendar.shortMonthSymbols
    }
}
