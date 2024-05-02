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
    
    func eventPosition(event: EKEvent) -> (x: CGFloat, y: CGFloat) {
        var eventPosition: (x: CGFloat, y: CGFloat) = (x:0, y:0)
        if let startDate = event.startDate {
            let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
            if let hour = startDateComponents.hour, let minute = startDateComponents.minute, hour >= 6 {
                let y = CGFloat(45.6  *  Float(hour - 6 ))
                eventPosition = (x: 54, y: 133.0 + y)
            }
        }
        return eventPosition
    }
}
