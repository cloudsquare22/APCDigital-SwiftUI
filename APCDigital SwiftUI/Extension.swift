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
    
    func isPast(compare: Date) -> Bool {
        var isPast = false
        var selfdc = Calendar.current.dateComponents(in: .current, from: self)
        var comparedc = Calendar.current.dateComponents(in: .current, from: compare)
        selfdc.hour = 0
        selfdc.minute = 0
        selfdc.second = 0
        selfdc.nanosecond = 0
        comparedc.hour = 0
        comparedc.minute = 0
        comparedc.second = 0
        comparedc.nanosecond = 0
        if selfdc.date! < comparedc.date! {
            isPast = true
        }
        return isPast
    }
    
    func isPastClose(compare: Date) -> Bool {
        var isPast = false
        var selfdc = Calendar.current.dateComponents(in: .current, from: self)
        var comparedc = Calendar.current.dateComponents(in: .current, from: compare)
        selfdc.hour = 0
        selfdc.minute = 0
        selfdc.second = 0
        selfdc.nanosecond = 0
        comparedc.hour = 0
        comparedc.minute = 0
        comparedc.second = 0
        comparedc.nanosecond = 0
        if selfdc.date! <= comparedc.date! {
            isPast = true
        }
        return isPast
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

extension UIView {
    func asImage() -> UIImage {
        //        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        //        return renderer.image { context in
        //            layer.render(in: context.cgContext)
        //        }
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
    
    func printHierarchy(level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        print("\(indent)\(type(of: self)) - frame: \(frame)")
        for subview in subviews {
            subview.printHierarchy(level: level + 1)
        }
    }
    
    func disableScrollViewBounce() {
        for subview in subviews {
            if let scrollView = subview as? UIScrollView {
//                print("**** found scroll view, disabling bounce ****")
                scrollView.bounces = false
                scrollView.alwaysBounceVertical = false
                scrollView.alwaysBounceHorizontal = false
                scrollView.isScrollEnabled = false
            }
            // 再帰的に探索
            subview.disableScrollViewBounce()
        }
    }
}
