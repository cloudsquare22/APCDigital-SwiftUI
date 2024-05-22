//
//  Extension.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation
import PencilKit
import SwiftUI

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

extension PKInkingTool.InkType {
    func minWidth() -> CGFloat {
        return self.validWidthRange.lowerBound
    }
}

extension Calendar {
    func withMondayAsFirstDayOfWeek() -> Calendar {
        var calendar = self
        calendar.firstWeekday = 2 // 1: Sunday, 2: Monday, ...
        return calendar
    }
}

extension Color {
    init(hex: UInt, displayP3: Bool = true) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        
        if displayP3 {
            self.init(.displayP3, red: red, green: green, blue: blue, opacity: 1.0)
        } else {
            self.init(red: red, green: green, blue: blue, opacity: 1.0)
        }
    }
}
