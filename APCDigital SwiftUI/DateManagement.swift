//
//  DateManagement.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation

@Observable class DateManagement {
    let dayLebelPosition: [Device.DType : [WeekDay1stMonday : (x: CGFloat, y:CGFloat)]] =
    [.ipad_pro_12_9_6th : [
        .monday: (60.0, 45.0),
        .tuesday: (208.0, 45.0),
        .wednesday: (356.0, 45.0),
        .thursday: (504.0, 45.0),
        .friday: (725.0, 45.0),
        .saturday: (873.0, 45.0),
        .sunday: (1021.0, 45.0)]]

    let monthLebelPosition: [Device.DType : (x: CGFloat, y:CGFloat)] =
    [.ipad_pro_12_9_6th : (1250, 40.0)]

    var days: [WeekDay1stMonday : Int] = [.monday: 2,
                                          .tuesday: 88,
                                          .wednesday: 77,
                                          .thursday: 66,
                                          .friday: 55,
                                          .saturday: 44,
                                          .sunday: 33]
    
    var pagestartday: Date? = nil
    var month: Int = 0
    var nextmonth: Int? = nil

    func getDayLebelPosition(weekDay: WeekDay1stMonday) -> (x: CGFloat, y: CGFloat) {
        var labelPosition: (x: CGFloat, y: CGFloat) = (0.0, 0.0)
        if let positions = self.dayLebelPosition[Device.getDevie()], let position = positions[weekDay] {
            labelPosition = position
        }
        return labelPosition
    }
    func getMonthLebelPosition() -> (x: CGFloat, y: CGFloat) {
        var labelPosition: (x: CGFloat, y: CGFloat) = (0.0, 0.0)
        if let position = self.monthLebelPosition[Device.getDevie()] {
            labelPosition = position
        }
        return labelPosition
    }

    func setPageStartday(direction: PageMondayDirection, selectday: Date = Date.now) {
        let matching = DateComponents(weekday: 2)
        let today = selectday
        let pageday = self.pagestartday ?? today
        switch direction {
        case .today:
            let weekday = Calendar.current.component(.weekday, from: today)
            if weekday != 2 {
                self.pagestartday = Calendar.current.nextDate(after: today, matching: matching, matchingPolicy: .nextTime, direction: .backward)!
            }
            else {
                self.pagestartday = today
            }
        case .next:
            self.pagestartday = Calendar.current.nextDate(after: pageday, matching: matching, matchingPolicy: .nextTime, direction: .forward)!
        case .back:
            self.pagestartday = Calendar.current.nextDate(after: pageday, matching: matching, matchingPolicy: .nextTime, direction: .backward)!
        }
        print("Page start day:\(self.pagestartday!.printStyleString(style: .medium))")
        
        self.nextmonth = nil
        for weekDay in WeekDay1stMonday.allCases {
            let weekDayRaw = weekDay.rawValue
            let date = self.pagestartday! + TimeInterval((86400 * weekDayRaw))
            var dateComponents = Calendar.current.dateComponents(in: .current, from: date)
            if weekDay == .sunday {
                dateComponents.setTimeInDateComponents(hour: 23, minute: 59, second: 59, nanosecond: 999)
            }
            else {
                dateComponents.setTimeInDateComponents(hour: 0, minute: 0, second: 0, nanosecond: 0)
            }
            self.days[weekDay] = dateComponents.day!
            if weekDay == .monday {
                self.month = dateComponents.month!
            }
            if weekDay == .sunday && self.month != dateComponents.month! {
                self.nextmonth = dateComponents.month
            }
        }
    }
}
