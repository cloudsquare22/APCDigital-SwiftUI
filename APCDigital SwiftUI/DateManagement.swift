//
//  DateManagement.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import Foundation

@Observable class DateManagement {
    typealias LabelViewData = (contents: String, x: CGFloat, y: CGFloat)
    
    let DAY_LABEL_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : (x: CGFloat, y:CGFloat)]] =
    [.ipad_pro_12_9_6th : [
        .monday:    (60.0, 80.0),
        .tuesday:   (208.0, 80.0),
        .wednesday: (356.0, 80.0),
        .thursday:  (504.0, 80.0),
        .friday:    (725.0, 80.0),
        .saturday:  (873.0, 80.0),
        .sunday:    (1021.0, 80.0)],
     .ipad_pro_13 : [
        .monday:    (61.0, 80.0),
        .tuesday:   (210.0, 80.0),
        .wednesday: (359.0, 80.0),
        .thursday:  (508.0, 80.0),
        .friday:    (731.0, 80.0),
        .saturday:  (881.0, 80.0),
        .sunday:    (1030.0, 80.0)]
    ]

    let REMAINING_LABEL_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : (x: CGFloat, y:CGFloat)]] =
    [.ipad_pro_12_9_6th : [
        .monday:    (93.0, 83.0),
        .tuesday:   (241.0, 83.0),
        .wednesday: (389.0, 83.0),
        .thursday:  (537.0, 83.0),
        .friday:    (758.0, 83.0),
        .saturday:  (906.0, 83.0),
        .sunday:    (1054.0, 83.0)],
     .ipad_pro_13 : [
        .monday:    (94.0, 83.0),
        .tuesday:   (243.0, 83.0),
        .wednesday: (392.0, 83.0),
        .thursday:  (541.0, 83.0),
        .friday:    (764.0, 83.0),
        .saturday:  (914.0, 83.0),
        .sunday:    (1063.0, 83.0)]
    ]

    let MONTH_LABEL_POSITION_MAP: [Device.DType : (x: CGFloat, y: CGFloat)] =
    [
        .ipad_pro_12_9_6th : 
            (1240, 80.0),
        .ipad_pro_13 : 
            (1255, 78.0)
    ]

    let FROMTO_LABEL_POSITION_MAP: [Device.DType : (x: CGFloat, y: CGFloat)] =
    [
        .ipad_pro_12_9_6th : 
            (1240, 130.0),
        .ipad_pro_13 :
            (1255, 130.0)
    ]

    let WEEKOFYEAR_LABEL_POSITION_MAP: [Device.DType : (x: CGFloat, y: CGFloat)] =
    [
        .ipad_pro_12_9_6th : 
            (1240, 388.0),
        .ipad_pro_13 : 
            (1255, 388.0)
    ]

    var days: [WeekDay1stMonday : Int] = [.monday: 2,
                                          .tuesday: 88,
                                          .wednesday: 77,
                                          .thursday: 66,
                                          .friday: 55,
                                          .saturday: 44,
                                          .sunday: 33]
    
    var daysDateComponents: [WeekDay1stMonday : DateComponents] = [.monday: DateComponents(),
                                                                   .tuesday: DateComponents(),
                                                                   .wednesday: DateComponents(),
                                                                   .thursday: DateComponents(),
                                                                   .friday: DateComponents(),
                                                                   .saturday: DateComponents(),
                                                                   .sunday: DateComponents()]
    var pagestartday: Date? = nil
    var month: Int = 0
    var nextmonth: Int? = nil

    func createDayLebelViewData(weekDay1stMonday: WeekDay1stMonday) -> LabelViewData {
        var viewData: LabelViewData = ("", 0.0, 0.0)
        if let positions = self.DAY_LABEL_POSITIONS_MAP[Device.getDevie()],
           let position = positions[weekDay1stMonday],
            let day = self.days[weekDay1stMonday] {
            viewData.x = position.x
            viewData.y = position.y
            viewData.contents = String(day)
        }
        return viewData
    }
    
    func createMonthLebelViewData() -> LabelViewData {
        var viewData: LabelViewData = ("", 0.0, 0.0)
        if let position = self.MONTH_LABEL_POSITION_MAP[Device.getDevie()],
           let mondayMonth = self.daysDateComponents[.monday]?.month,
           let sundayMonth = self.daysDateComponents[.sunday]?.month {
            viewData.x = position.x
            viewData.y = position.y
            if mondayMonth == sundayMonth {
                viewData.contents = String(mondayMonth)
            }
            else {
                viewData.contents = "\(mondayMonth)/\(sundayMonth)"
            }
        }
        return viewData
    }

    func createFromToLebelViewData() -> LabelViewData {
        var viewData: LabelViewData = ("", 0.0, 0.0)
        if let position = self.FROMTO_LABEL_POSITION_MAP[Device.getDevie()],
           let mondayMonth = self.daysDateComponents[.monday]?.month,
           let mondayDay = self.daysDateComponents[.monday]?.day,
           let sundayMonth = self.daysDateComponents[.sunday]?.month,
           let sundayDay = self.daysDateComponents[.sunday]?.day{
            viewData.x = position.x
            viewData.y = position.y
            let fromString = Calendar.shortMonthSymbols(local: Locale(identifier: "en"))[mondayMonth - 1].uppercased() + " " + String(mondayDay)
            let toString = "to " + Calendar.shortMonthSymbols(local: Locale(identifier: "en"))[sundayMonth - 1].uppercased() + " " + String(sundayDay)
            viewData.contents = fromString + "\n" + toString
        }
        return viewData
    }

    func createWeekOfYearViewData() -> LabelViewData {
        var viewData: LabelViewData = ("", 0.0, 0.0)
        if let position = self.WEEKOFYEAR_LABEL_POSITION_MAP[Device.getDevie()],
           let mondayDate = self.pagestartday {
            viewData.x = position.x
            viewData.y = position.y
            viewData.contents = String(Calendar.current.component(.weekOfYear, from: mondayDate)) + " week"
        }
        return viewData
    }


    func createRemainingLebelViewData(weekDay1stMonday: WeekDay1stMonday) -> LabelViewData {
        var viewData: LabelViewData = ("", 0.0, 0.0)
        if let positions = self.REMAINING_LABEL_POSITIONS_MAP[Device.getDevie()], let position = positions[weekDay1stMonday] {
            viewData.x = position.x
            viewData.y = position.y
        }
        if let dayComponentes = self.daysDateComponents[weekDay1stMonday], let day = dayComponentes.date {
            let dateYearFirst = Calendar.current.date(from: DateComponents(year: dayComponentes.year, month: 1, day: 1, hour: 0, minute: 0, second: 0))!
            let dateYearEnd = Calendar.current.date(from: DateComponents(year: dayComponentes.year, month: 12, day: 31, hour: 23, minute: 59, second: 59))!
            let elapsed = Calendar.current.dateComponents([.day], from: dateYearFirst, to: day)
            let remaining = Calendar.current.dateComponents([.day], from: day, to: dateYearEnd)
            viewData.contents = String(format: "%d-%d", elapsed.day! + 1, remaining.day!)
        }
        return viewData
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
            self.daysDateComponents[weekDay] = dateComponents
            if weekDay == .monday {
                self.month = dateComponents.month!
            }
            if weekDay == .sunday && self.month != dateComponents.month! {
                self.nextmonth = dateComponents.month
            }
        }
    }
}
