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
    var calendars: [EKCalendar] = []
    
    let eventPositionsMap: [Device.DType : [WeekDay1stMonday : (x:CGFloat, y:CGFloat)]] = [.ipad_pro_12_9_6th : [.monday : (55, 133.5),
                                                                                                                 .tuesday: (203, 133.5),
                                                                                                                 .wednesday: (351, 133.5),
                                                                                                                 .thursday: (499, 133.5),
                                                                                                                 .friday: (720, 133.5),
                                                                                                                 .saturday: (868, 133.5),
                                                                                                                 .sunday: (1016, 133.5)]]
    
    func updateEvents(startDay: DateComponents, endDay: DateComponents) {
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: startDay.date!, end: endDay.date!, calendars: nil)
        self.events = eventStore.events(matching: predicate)
        print(events)
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
        var eventViewData = EventViewData(x: 0.0, y: 0.0, height: 0.0, minuteSymbolName: "circle")
        if let startDate = event.startDate, let endDate = event.endDate {
            let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
            let endDateComponents = Calendar.current.dateComponents(in: .current, from: endDate)
            if let hour = startDateComponents.hour, let minute = startDateComponents.minute, hour >= 6 {
                if let eventPositions = self.eventPositionsMap[Device.getDevie()] ,
                    let eventPosition = eventPositions[self.weekDayToWeekDay1stMonday(weekDay: startDateComponents.weekday)] {
                    let diff = endDate.timeIntervalSince(startDate) // seconds
                    eventViewData.x = eventPosition.x
                    eventViewData.y = eventPosition.y + CGFloat(45.5  *  Float(hour - 6 )) + CGFloat(45.5 / 60 * Float(minute))
                    eventViewData.height = CGFloat((45.5 / 60) * (diff / 60))
                    switch minute {
                    case 0, 30:
                        eventViewData.minuteSymbolName = "circle"
                    case 51, 52, 53, 54, 55, 56, 57, 58, 59:
                        eventViewData.minuteSymbolName = "circle"
                    default:
                        eventViewData.minuteSymbolName = String(minute) + ".circle"
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
