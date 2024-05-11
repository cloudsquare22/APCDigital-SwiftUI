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
    
    let ONE_HOUR_HEIGHT: CGFloat = 45.6
    let MOVE_SYMBOLS: [String] = ["🚗", "🚃"]

    typealias XYWidth = (x:CGFloat, y:CGFloat, width: CGFloat)
    
    let EVENT_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : XYWidth]] =
    [.ipad_pro_12_9_6th : [.monday :   (  55.0, 169.0, 140.0),
                           .tuesday:   ( 203.0, 169.0, 140.0),
                           .wednesday: ( 351.0, 169.0, 140.0),
                           .thursday:  ( 499.0, 169.0, 143.5),
                           .friday:    ( 720.0, 169.0, 140.0),
                           .saturday:  ( 868.0, 169.0, 140.0),
                           .sunday:    (1016.0, 169.0, 143.5)]]

    let EVENT_ALLDAY_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : XYWidth]] =
    [.ipad_pro_12_9_6th : [.monday :   (  60.0, 105.0, 140.0),
                           .tuesday:   ( 208.0, 105.0, 140.0),
                           .wednesday: ( 356.0, 105.0, 140.0),
                           .thursday:  ( 504.0, 105.0, 140.0),
                           .friday:    ( 725.0, 105.0, 140.0),
                           .saturday:  ( 873.0, 105.0, 140.0),
                           .sunday:    (1021.0, 105.0, 140.0)]]

    let HOLIDAY_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : XYWidth]] =
    [.ipad_pro_12_9_6th : [.monday :   (  96.0, 93.0, 100.0),
                           .tuesday:   ( 244.0, 93.0, 100.0),
                           .wednesday: ( 392.0, 93.0, 100.0),
                           .thursday:  ( 540.0, 93.0, 100.0),
                           .friday:    ( 761.0, 93.0, 100.0),
                           .saturday:  ( 909.0, 93.0, 100.0),
                           .sunday:    (1057.0, 93.0, 100.0)]]

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
                    if let startHour = startDateComponents.hour,
                       let startMinute = startDateComponents.minute,
                       let endHour = endDateComponents.hour,
                       let endMinute = endDateComponents.minute {
                        if 0 <= startHour, startHour < 6 {
                            if endHour < 6 || endHour == 6 && endMinute == 0 {
                                print("[A] \(event.title ?? "")")
                                self.allDayAreaEvents.append(event)
                            }
                            else {
                                self.mainAreaEvents.append(event)
                            }
                        }
                        else if startHour == 23, 31 <= startMinute {
                            print("[B] \(event.title ?? "")")
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
            print(calendar)
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
//        print(calendars)
    }
    
    func getPosition(positionsMap: [Device.DType : [WeekDay1stMonday : XYWidth]], weekDay: Int?) -> XYWidth? {
        self.getPosition(positionsMap: positionsMap, weekDay1stMonday: self.weekDayToWeekDay1stMonday(weekDay: weekDay))
    }

    func getPosition(positionsMap: [Device.DType : [WeekDay1stMonday : XYWidth]], weekDay1stMonday: WeekDay1stMonday) -> XYWidth? {
        var position: XYWidth? = nil
        if let positions = positionsMap[Device.getDevie()] {
            position = positions[weekDay1stMonday]
        }
        return position
    }

    func getHeight(startDate: Date, endDate: Date) -> CGFloat {
        var height: CGFloat = ONE_HOUR_HEIGHT
        let diff: TimeInterval = endDate.timeIntervalSince(startDate) // seconds
        height = CGFloat((ONE_HOUR_HEIGHT / 60) * (diff / 60))
        return height
    }
    
    func isMove(title: String) -> Bool {
        MOVE_SYMBOLS.contains(String(title.prefix(1)))
    }
    
    func createEventViewData(event: EKEvent) -> EventViewData {
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
                if let position = self.getPosition(positionsMap: self.EVENT_POSITIONS_MAP, weekDay: startDateComponents.weekday) {
                    // 内容
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
                    
                    // 移動：線中央にする
                    eventViewData.isMove = self.isMove(title: event.title)

                    // 高さ：標準
                    eventViewData.height = self.getHeight(startDate: startDate, endDate: endDate)

                    // 開始マーク：標準（期間外補正：開始で上書きケースあり）
                    switch startMinute {
                    case 0, 30:
                        eventViewData.startSymbolName = "circle"
                    case 51, 52, 53, 54, 55, 56, 57, 58, 59:
                        eventViewData.startSymbolName = "circle"
                    default:
                        eventViewData.startSymbolName = String(startMinute) + ".circle"
                    }

                    // 座標：標準
                    eventViewData.x = position.x
                    eventViewData.y = position.y + (ONE_HOUR_HEIGHT * CGFloat(startHour - 6 )) + (ONE_HOUR_HEIGHT / 60 * CGFloat(startMinute))

                    // 幅
                    eventViewData.width = position.width

                    // 背景色
                    eventViewData.color = self.cgToUIColor(cgColor: event.calendar.cgColor)

                    // 期間外補正：開始
                    if startHour < 6 {
                        var startDateComponentsAdjust = startDateComponents
                        startDateComponentsAdjust.hour = 6
                        startDateComponentsAdjust.minute = 0
                        eventViewData.dispTopLine = false
                        eventViewData.startSymbolName = "arrowtriangle.down"
                        if let startDateAdjust = startDateComponentsAdjust.date {
                            eventViewData.height = self.getHeight(startDate: startDateAdjust, endDate: endDate)
                            eventViewData.contents = AttributedString(String(format: "%d:%02d〜", startDateComponents.hour!, startDateComponents.minute!)) + eventViewData.contents
                        }
                        eventViewData.y = position.y + (ONE_HOUR_HEIGHT * CGFloat(startDateComponentsAdjust.hour! - 6 )) + (ONE_HOUR_HEIGHT / 60 * CGFloat(startDateComponentsAdjust.minute!))
                    }
                    
                    // 期間外補正；終了
                    if (startDay == endDay && 23 == endHour && 31 <= endMinute) || (startDay != endDay) {
                        var endDateComponentsLimit = endDateComponents
                        endDateComponentsLimit.hour = 23
                        endDateComponentsLimit.minute = 30
                        endDateComponentsLimit.day = startDay
                        if let endDateLimit = endDateComponentsLimit.date {
                            eventViewData.height = self.getHeight(startDate: startDate, endDate: endDateLimit)
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
    
    func createAllDayEventViewData(weekDay1stMonday: WeekDay1stMonday) -> EventViewData {
        var eventViewData = EventViewData()
        
        // 内容
        var contents: AttributedString = ""
        for event in allDayAreaEvents {
            if let startDate = event.startDate {
                let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
                if let startHour = startDateComponents.hour,
                   let startMinute = startDateComponents.minute {
                    if self.weekDayToWeekDay1stMonday(weekDay: startDateComponents.weekday) == weekDay1stMonday {
                        if contents.runs.isEmpty == false {
                            contents = contents + "\n"
                        }
                        var startDateString:String = ""
                        if event.isAllDay == false {
                            startDateString = String(format: "%d:%02d ", startHour, startMinute)
                        }
                        var attributedString = AttributedString("●" + startDateString + event.title)
                        let range = attributedString.range(of: "●")
                        let color = self.cgToUIColor(cgColor: event.calendar.cgColor, alpha: 1.0)
                        attributedString[range!].foregroundColor = color
                        if let rangeDate = attributedString.range(of: startDateString) {
                            attributedString[rangeDate].foregroundColor = Color(.basicGreen)
                        }
                        contents = contents + attributedString
                    }
                }
            }
        }
        eventViewData.contents = contents
        
        // 座標幅
        if let position = self.getPosition(positionsMap: self.EVENT_ALLDAY_POSITIONS_MAP, weekDay1stMonday: weekDay1stMonday) {
            eventViewData.x = position.x
            eventViewData.y = position.y
            eventViewData.width = position.width
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
        
        // 座標幅
        if let position = self.getPosition(positionsMap: self.HOLIDAY_POSITIONS_MAP, weekDay1stMonday: weekDay1stMonday) {
            eventViewData.x = position.x
            eventViewData.y = position.y
            eventViewData.width = position.width
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
