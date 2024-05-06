//
//  EventManagement.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/02.
//

import Foundation
import EventKit
import SwiftUI

@Observable class EventManagement {
    let eventStore = EKEventStore()
    var events: [EKEvent] = []
    var mainAreaEvents: [EKEvent] = []
    var allDayAreaEvents: [EKEvent] = []
    var holidayEvents: [EKEvent] = []
    var calendars: [EKCalendar] = []
    
    let eventPositionsMap: [Device.DType : [WeekDay1stMonday : (x:CGFloat, y:CGFloat, width: CGFloat)]] =
    [.ipad_pro_12_9_6th : [.monday :   (  55.0, 133.5, 140.0),
                           .tuesday:   ( 203.0, 133.5, 140.0),
                           .wednesday: ( 351.0, 133.5, 140.0),
                           .thursday:  ( 499.0, 133.5, 143.5),
                           .friday:    ( 720.0, 133.5, 140.0),
                           .saturday:  ( 868.0, 133.5, 140.0),
                           .sunday:    (1016.0, 133.5, 143.5)]]

    let eventAllDayPositionsMap: [Device.DType : [WeekDay1stMonday : (x:CGFloat, y:CGFloat, width: CGFloat)]] =
    [.ipad_pro_12_9_6th : [.monday :   (  60.0, 70.0, 140.0),
                           .tuesday:   ( 208.0, 70.0, 140.0),
                           .wednesday: ( 356.0, 70.0, 140.0),
                           .thursday:  ( 504.0, 70.0, 140.0),
                           .friday:    ( 725.0, 70.0, 140.0),
                           .saturday:  ( 873.0, 70.0, 140.0),
                           .sunday:    (1021.0, 70.0, 140.0)]]

    let holidayPositionsMap: [Device.DType : [WeekDay1stMonday : (x:CGFloat, y:CGFloat, width: CGFloat)]] =
    [.ipad_pro_12_9_6th : [.monday :   (  96.0, 59.0, 100.0),
                           .tuesday:   ( 244.0, 59.0, 100.0),
                           .wednesday: ( 392.0, 59.0, 100.0),
                           .thursday:  ( 540.0, 59.0, 100.0),
                           .friday:    ( 761.0, 59.0, 100.0),
                           .saturday:  ( 909.0, 59.0, 100.0),
                           .sunday:    (1057.0, 59.0, 100.0)]]

    func updateEvents(startDay: DateComponents, endDay: DateComponents) {
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: startDay.date!, end: endDay.date!, calendars: nil)
        self.events = eventStore.events(matching: predicate)
//        print(events)
        self.allDayAreaEvents = []
        self.mainAreaEvents = []
        self.holidayEvents = []
        for event in events {
            if let calendar = event.calendar, calendar.title == "日本の祝日" {
                self.holidayEvents.append(event)
            }
            else if let calendar = event.calendar, calendar.title == "誕生日" {
                continue
            }
            else if event.isAllDay == true {
                self.allDayAreaEvents.append(event)
            }
            else {
                if let startDate = event.startDate, let endDate = event.endDate {
                    let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
                    let endDateComponents = Calendar.current.dateComponents(in: .current, from: endDate)
                    if let startDay = startDateComponents.day,
                       let startHour = startDateComponents.hour,
                       let startMinute = startDateComponents.minute,
                       let endDay = endDateComponents.day,
                       let endHour = endDateComponents.hour,
                       let endMinute = endDateComponents.minute {
                        if 0 <= startHour, startHour < 6 {
                            if endHour < 6 || endHour == 6 && endMinute == 00 {
                                print("[A] \(startDay) \(startHour):\(startMinute)〜\(endDay) \(endHour):\(endMinute) \(event.title ?? "")")
                                self.allDayAreaEvents.append(event)
                            }
                            else {
                                self.mainAreaEvents.append(event)
                            }
                        }
                        else if startHour == 23, 31 <= startMinute {
                            print("[B] \(startDay) \(startHour):\(startMinute)〜\(endDay) \(endHour):\(endMinute) \(event.title ?? "")")
                            self.allDayAreaEvents.append(event)
                        }
                        else {
                            self.mainAreaEvents.append(event)
                        }
                    }
                }
            }
        }
    }
    
    func updateCalendars() {
        let calendarAll = eventStore.calendars(for: .event)
        self.calendars = []
        for calendar in calendarAll {
            switch calendar.type {
            case .local, .calDAV,
                    .subscription where calendar.title != "日本の祝日":
                self.calendars.append(calendar)
            default:
                break
            }
        }
        self.calendars.sort() {
            $0.title < $1.title
        }
        print(calendars)
    }
    
    func eventPosition(event: EKEvent) -> EventViewData {
        var eventViewData = EventViewData()
        if let startDate = event.startDate, let endDate = event.endDate {
            let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
            let endDateComponents = Calendar.current.dateComponents(in: .current, from: endDate)
            if let startDay = startDateComponents.day,
               let startHour = startDateComponents.hour,
               let startMinute = startDateComponents.minute,
               let endDay = endDateComponents.day,
               let endHour = endDateComponents.hour,
               let endMinute = endDateComponents.minute {
//                print("\(startDay) \(startHour):\(startMinute)〜\(endDay) \(endHour):\(endMinute) \(event.title ?? "")")
                if let eventPositions = self.eventPositionsMap[Device.getDevie()] ,
                    let eventPosition = eventPositions[self.weekDayToWeekDay1stMonday(weekDay: startDateComponents.weekday)] {
                    var contents: AttributedString = AttributedString(event.title)
                    if let location = event.location, location.isEmpty == false {
                        contents = contents + AttributedString("(" + location + ")")
                    }
                    if let notes = event.notes {
                        if notes.starts(with: "【memo on】\n") == true {
                            let text = notes.replacingOccurrences(of: "【memo on】\n", with: "")
                            contents = contents + "\n" + AttributedString(text)
                        }
                    }
                    eventViewData.contents = contents
                    
                    if event.title.starts(with: "🚃") == true || event.title.starts(with: "🚗") == true{
                        eventViewData.isMove = true
                    }

                    // 高さ：標準
                    let diff = endDate.timeIntervalSince(startDate) // seconds
                    eventViewData.height = CGFloat((45.5 / 60) * (diff / 60))

                    switch startMinute {
                    case 0, 30:
                        eventViewData.startSymbolName = "circle"
                    case 51, 52, 53, 54, 55, 56, 57, 58, 59:
                        eventViewData.startSymbolName = "circle"
                    default:
                        eventViewData.startSymbolName = String(startMinute) + ".circle"
                    }

                    // 期間外：開始
                    var startHourAdjust = startHour
                    var startMinuteAdjust = startMinute
                    var startDateComponentsAdjust = startDateComponents
                    if startHour < 6 {
                        startDateComponentsAdjust.hour = 6
                        startDateComponentsAdjust.minute = 0
                        startHourAdjust = 6
                        startMinuteAdjust = 0
                        eventViewData.dispTopLine = false
                        eventViewData.startSymbolName = "arrowtriangle.down"
                        if let startDateAdjust = startDateComponentsAdjust.date {
                            let diff = endDate.timeIntervalSince(startDateAdjust) // seconds
                            eventViewData.height = CGFloat((45.5 / 60) * (diff / 60))
                            eventViewData.contents = AttributedString(String(format: "%d:%02d〜", startHour, startMinute)) + eventViewData.contents
                        }
                    }
                    
                    eventViewData.x = eventPosition.x
                    eventViewData.y = eventPosition.y + CGFloat(45.5  *  Float(startHourAdjust - 6 )) + CGFloat(45.5 / 60 * Float(startMinuteAdjust))
                    eventViewData.width = eventPosition.width
                    
                    // 期間外；終了
                    if (startDay == endDay && 23 == endHour && 31 <= endMinute) ||
                                (startDay != endDay) {
                        var endDateComponentsLimit = endDateComponents
                        endDateComponentsLimit.hour = 23
                        endDateComponentsLimit.minute = 30
                        endDateComponentsLimit.day = startDay
                        if let endDateLimit = endDateComponentsLimit.date {
                            let diff = endDateLimit.timeIntervalSince(startDate) // seconds
                            eventViewData.height = CGFloat((45.5 / 60) * (diff / 60))
                            eventViewData.contents =  eventViewData.contents + AttributedString(String(format: "\n〜%d:%02d", endHour, endMinute))
                        }
                        eventViewData.endSymbolName = "arrowtriangle.up"
                        eventViewData.endSymbolYAdjust = 5.0
                        eventViewData.dispBottomLine = false
                    }
                }
            }
        }
        return eventViewData
    }
    
    func createAllDayViewData(weekDay1stMonday: WeekDay1stMonday) -> EventViewData {
        var eventViewData = EventViewData()
        var contents: AttributedString = ""
        for event in allDayAreaEvents {
            if let startDate = event.startDate, let endDate = event.endDate {
                let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
                let endDateComponents = Calendar.current.dateComponents(in: .current, from: endDate)
                if let startDay = startDateComponents.day,
                   let startHour = startDateComponents.hour,
                   let startMinute = startDateComponents.minute,
                   let endDay = endDateComponents.day,
                   let endHour = endDateComponents.hour,
                   let endMinute = endDateComponents.minute {
                    if self.weekDayToWeekDay1stMonday(weekDay: startDateComponents.weekday) == weekDay1stMonday {
                        if contents.runs.isEmpty == false {
                            contents = contents + "\n"
                        }
                        if event.isAllDay == true {
                            var attributedString = AttributedString("●" + event.title)
                            let range = attributedString.range(of: "●")
                            let color = self.cgToUIColor(cgColor: event.calendar.cgColor, alpha: 1.0)
                            attributedString[range!].foregroundColor = color
                            contents = contents + attributedString
                        }
                        else {
                            let startDateString = String(format: "%d:%02d ", startHour, startMinute)
                            var attributedString = AttributedString("●" + startDateString + event.title)
                            let range = attributedString.range(of: "●")
                            let color = self.cgToUIColor(cgColor: event.calendar.cgColor, alpha: 1.0)
                            attributedString[range!].foregroundColor = color
                            let rangeDate = attributedString.range(of: startDateString)
                            attributedString[rangeDate!].foregroundColor = Color(.basicGreen)
                            contents = contents + attributedString
                        }
                    }
                }
            }
        }
        eventViewData.contents = contents
        if let eventPositions = self.eventAllDayPositionsMap[Device.getDevie()] ,
           let eventPosition = eventPositions[weekDay1stMonday] {
            eventViewData.x = eventPosition.x
            eventViewData.y = eventPosition.y
            eventViewData.width = eventPosition.width
        }
        return eventViewData
    }

    func createHolidayViewData(weekDay1stMonday: WeekDay1stMonday) -> EventViewData {
        var eventViewData = EventViewData()
        for event in holidayEvents {
            if let startDate = event.startDate {
                let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
                if self.weekDayToWeekDay1stMonday(weekDay: startDateComponents.weekday) == weekDay1stMonday {
                    eventViewData.contents = AttributedString(event.title)
                    break
                }
            }
        }
        if let eventPositions = self.holidayPositionsMap[Device.getDevie()] ,
           let eventPosition = eventPositions[weekDay1stMonday] {
            eventViewData.x = eventPosition.x
            eventViewData.y = eventPosition.y
            eventViewData.width = eventPosition.width
        }
        return eventViewData
    }

    func cgToUIColor(cgColor: CGColor?, alpha: CGFloat = 0.3) -> Color {
        var color: Color = .clear
        if let cgColor = cgColor {
            color = Color(uiColor: UIColor(red: cgColor.components![0],
                                           green: cgColor.components![1],
                                           blue: cgColor.components![2],
                                           alpha: alpha))
        }
        return color
    }

    func weekDayToWeekDay1stMonday(weekDay: Int?) -> WeekDay1stMonday {
        var weekDay1stMonday: WeekDay1stMonday = .monday
        if let weekDay = weekDay {
            switch weekDay {
            case 1:
                weekDay1stMonday = .sunday
            case 2:
                weekDay1stMonday = .monday
            case 3:
                weekDay1stMonday = .tuesday
            case 4:
                weekDay1stMonday = .wednesday
            case 5:
                weekDay1stMonday = .thursday
            case 6:
                weekDay1stMonday = .friday
            case 7:
                weekDay1stMonday = .saturday
            default:
                break;
            }
        }
        return weekDay1stMonday
    }
}
