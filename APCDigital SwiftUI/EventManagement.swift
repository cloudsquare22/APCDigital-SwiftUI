//
//  EventManagement.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/02.
//

import Foundation
import EventKit

@Observable class EventManagement {
    let eventStore = EKEventStore()
    var events: [EKEvent] = []
    var mainAreaEvents: [EKEvent] = []
    var allDayAreaEvents: [EKEvent] = []
    var calendars: [EKCalendar] = []
    
    let eventPositionsMap: [Device.DType : [WeekDay1stMonday : (x:CGFloat, y:CGFloat, width: CGFloat)]] =
    [.ipad_pro_12_9_6th : [.monday : (55, 133.5, 140.0),
                           .tuesday: (203, 133.5, 140.0),
                           .wednesday: (351, 133.5, 140.0),
                           .thursday: (499, 133.5, 143.5),
                           .friday: (720, 133.5, 140.0),
                           .saturday: (868, 133.5, 140.0),
                           .sunday: (1016, 133.5, 143.5)]]
    
    func updateEvents(startDay: DateComponents, endDay: DateComponents) {
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: startDay.date!, end: endDay.date!, calendars: nil)
        self.events = eventStore.events(matching: predicate)
//        print(events)
        self.allDayAreaEvents = []
        self.mainAreaEvents = []
        for event in events {
            if event.isAllDay == true {
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
                    var contents: String = event.title ?? "-"
                    if let notes = event.notes {
                        if notes.starts(with: "【memo on】\n") == true {
                            let text = notes.replacingOccurrences(of: "【memo on】\n", with: "")
                            contents = contents + "\n" + text
                        }
                    }
                    eventViewData.contents = contents

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
                            eventViewData.contents = String(format: "%d:%02d〜", startHour, startMinute) + eventViewData.contents
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
                            eventViewData.contents =  eventViewData.contents + String(format: "\n〜%d:%02d", endHour, endMinute)
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
