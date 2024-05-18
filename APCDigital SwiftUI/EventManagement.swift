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
    var pageStartDate: Date = Date.now
    var pageEndDate: Date = Date.now

    @ObservationIgnored
    var mainAreaEventViewDataMap: [String: (eventViewData: EventViewData, event: EKEvent)] = [:]
    
    @ObservationIgnored
    var operationEventData: EventData? = nil
    @ObservationIgnored
    var operationEKEvents: [EKEvent]? = nil
    @ObservationIgnored
    var operationPoint: CGPoint = .zero

    var ONE_HOUR_HEIGHT: CGFloat {
        if Device.getDevie() == .ipad_pro_12_9_6th {
            return 45.6
        }
        else if Device.getDevie() == .ipad_pro_13 {
            return 45.85
        }
        return 45.6
    }
    let MOVE_SYMBOLS: [String] = ["🚗", "🚃"]

    typealias XYWidth = (x:CGFloat, y:CGFloat, width: CGFloat)
    
    let EVENT_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : XYWidth]] =
    [
        .ipad_pro_12_9_6th : 
            [.monday :   (  55.0, 169.0, 140.0),
             .tuesday:   ( 203.0, 169.0, 140.0),
             .wednesday: ( 351.0, 169.0, 140.0),
             .thursday:  ( 499.0, 169.0, 143.5),
             .friday:    ( 720.0, 169.0, 140.0),
             .saturday:  ( 868.0, 169.0, 140.0),
             .sunday:    (1016.0, 169.0, 143.5)],
        .ipad_pro_13 :
            [.monday :   (  56.0, 171.5, 140.0),
             .tuesday:   ( 205.0, 171.5, 140.0),
             .wednesday: ( 354.0, 171.5, 140.0),
             .thursday:  ( 503.0, 171.5, 143.5),
             .friday:    ( 726.5, 171.5, 140.0),
             .saturday:  ( 875.0, 171.5, 140.0),
             .sunday:    (1024.0, 171.5, 143.5)]
    ]

    let EVENT_ALLDAY_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : XYWidth]] =
    [
        .ipad_pro_12_9_6th : 
            [.monday :   (  60.0, 105.0, 140.0),
             .tuesday:   ( 208.0, 105.0, 140.0),
             .wednesday: ( 356.0, 105.0, 140.0),
             .thursday:  ( 504.0, 105.0, 140.0),
             .friday:    ( 725.0, 105.0, 140.0),
             .saturday:  ( 873.0, 105.0, 140.0),
             .sunday:    (1021.0, 105.0, 140.0)],
        .ipad_pro_13 :       
            [.monday :   (  61.0, 105.5, 140.0),
             .tuesday:   ( 210.0, 105.5, 140.0),
             .wednesday: ( 359.0, 105.5, 140.0),
             .thursday:  ( 508.0, 105.5, 140.0),
             .friday:    ( 731.0, 105.5, 140.0),
             .saturday:  ( 881.0, 105.5, 140.0),
             .sunday:    (1030.0, 105.5, 140.0)]
    ]

    let HOLIDAY_POSITIONS_MAP: [Device.DType : [WeekDay1stMonday : XYWidth]] =
    [
        .ipad_pro_12_9_6th : 
            [.monday :   (  96.0, 93.0, 100.0),
             .tuesday:   ( 244.0, 93.0, 100.0),
             .wednesday: ( 392.0, 93.0, 100.0),
             .thursday:  ( 540.0, 93.0, 100.0),
             .friday:    ( 761.0, 93.0, 100.0),
             .saturday:  ( 909.0, 93.0, 100.0),
             .sunday:    (1057.0, 93.0, 100.0)],
        .ipad_pro_13 :
            [.monday :   (  97.0, 93.0, 100.0),
             .tuesday:   ( 246.0, 93.0, 100.0),
             .wednesday: ( 395.0, 93.0, 100.0),
             .thursday:  ( 544.0, 93.0, 100.0),
             .friday:    ( 767.0, 93.0, 100.0),
             .saturday:  ( 917.0, 93.0, 100.0),
             .sunday:    (1066.0, 93.0, 100.0)],
    ]

    func updateEvents(startDay: DateComponents, endDay: DateComponents) {
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: startDay.date!, end: endDay.date!, calendars: nil)
        self.pageStartDate = startDay.date!
        self.pageEndDate = endDay.date!
        self.events = eventStore.events(matching: predicate)
//        print(events)
        self.allDayAreaEvents = []
        self.mainAreaEvents = []
        self.holidayEvents = []
        self.mainAreaEventViewDataMap = [:]
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
            case .local, .calDAV:
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
        self.mainAreaEventViewDataMap[event.calendarItemIdentifier] = (eventViewData: eventViewData, event: event)
        return eventViewData
    }
    
    func createAllDayEventViewData(weekDay1stMonday: WeekDay1stMonday) -> EventViewData {
        var eventViewData = EventViewData()
        
        // 内容
        var contents: AttributedString = ""
        for event in allDayAreaEvents {
            if let startDate = event.startDate, let endDate = event.endDate {
                let startDateComponents = Calendar.current.dateComponents(in: .current, from: startDate)
                if let startHour = startDateComponents.hour,
                   let startMinute = startDateComponents.minute {
                    if self.isWeekDayRange(startDate: startDate, endDate: endDate, weekDay1stMonday: weekDay1stMonday) == true {
//                    if self.weekDayToWeekDay1stMonday(weekDay: startDateComponents.weekday) == weekDay1stMonday {
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
    
    func isWeekDayRange(startDate: Date, endDate: Date, weekDay1stMonday: WeekDay1stMonday) -> Bool {
        var isWeekDayRange: Bool = false
        var targetDate: Date = startDate
        while targetDate <= endDate {
            if pageStartDate <= targetDate && targetDate <= endDate {
                let targetDateComponents = Calendar.current.dateComponents(in: .current, from: targetDate)
                if self.weekDayToWeekDay1stMonday(weekDay: targetDateComponents.weekday) == weekDay1stMonday {
                    isWeekDayRange = true
                    break
                }
            }
            targetDate = targetDate + TimeInterval(24 * 60 * 60)
        }
        return isWeekDayRange
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
    
    func createMainAreaEventDatas(point: CGPoint) -> [EventData] {
        var eventDatas: [EventData] = []
        let events: [EKEvent] = self.checkMainAreaEvents(point: point)
        for event in events {
            var eventData: EventData = EventData()
            eventData.eKEvent = event
            eventData.title = event.title
            if eventData.title.hasPrefix("□") == true {
                eventData.todo = true
                eventData.title.removeFirst()
            }
            eventData.location = event.location ?? ""
            eventData.calendar = event.calendarItemIdentifier
            eventData.allDay = event.isAllDay
            if event.isAllDay {
                eventData.notification = false
            }
            eventData.startDate = event.startDate
            eventData.endDate = event.endDate
            if let notes = event.notes {
                eventData.memoText = notes
                if eventData.memoText.hasPrefix("【memo on】\n") {
                    eventData.memo = true
                    eventData.memoText = eventData.memoText.replacingOccurrences(of: "【memo on】\n", with: "")
                }
            }
        }
        return eventDatas
    }
    
    func checkMainAreaEvents(point: CGPoint) -> [EKEvent] {
        var events: [EKEvent] = []
        for (_, value) in mainAreaEventViewDataMap {
            guard value.event.calendar.type == .calDAV else {
                continue
            }
            let eventViewData: EventViewData = value.eventViewData
            if eventViewData.x <= point.x && point.x <= eventViewData.x + eventViewData.width &&
                eventViewData.y <= point.y && point.y <= eventViewData.y + eventViewData.height {
                print(value.event.title!)
                events.append(value.event)
            }
        }
        return events
    }
    
    func createEventData(point: CGPoint, daysDateComponents: [WeekDay1stMonday : DateComponents]) -> EventData? {
        var eventData: EventData? = nil
        for weekDay1stMonday in WeekDay1stMonday.allCases {
            if let xywith = self.getPosition(positionsMap: self.EVENT_POSITIONS_MAP, weekDay1stMonday: weekDay1stMonday) {
                if xywith.x <= point.x, point.x <= xywith.x + xywith.width {
                    if let dateComponents = daysDateComponents[weekDay1stMonday] {
                        var startDateComponents = dateComponents
                        print("\(#function):\(weekDay1stMonday)")
                        let (startH, startM) = self.pointToHM(point: point, xywith: xywith)
                        if 24 <= startH || (startH == 23 && startM == 30) {
                            break
                        }
                        if self.calendars.count <= 0 {
                            break
                        }
                        eventData = EventData()
                        eventData?.calendar = self.calendars[0].calendarIdentifier
                        startDateComponents.hour = startH
                        startDateComponents.minute = startM
                        eventData!.startDate = startDateComponents.date!
                        eventData!.endDate = startDateComponents.date! + (60 * 60)
                        if point.y < xywith.y {
                            eventData!.allDay = true
                        }
                        break
                    }
                }
            }
        }
        return eventData
    }
    
    func pointToHM(point: CGPoint, xywith: XYWidth) -> (startH: Int, startM: Int) {
        let pointH = ((point.y - xywith.y) / self.ONE_HOUR_HEIGHT) + 6
        var startH = Int(pointH)
        if point.y < xywith.y {
            startH = 0
        }
        var startM = 0
        if pointH > CGFloat(startH) + 0.5 {
            startM = 30
        }
        print("\(startH):\(startM)")
        return (startH, startM)
    }
    
    func saveEventData(eventData: EventData) {
        guard let calendar = self.getCalendar(id: eventData.calendar) else {
            return
        }
        if eventData.eKEvent == nil {
            let event = EKEvent(eventStore: eventStore)
            event.title = eventData.todo == true ? "□" : ""
            event.title = event.title + eventData.title
            event.location = eventData.location
            event.startDate = eventData.startDate
            event.endDate = eventData.endDate
            event.calendar = calendar
            if eventData.memo == true {
                event.notes = "【memo on】\n" + eventData.memoText
            }
            else {
                event.notes = eventData.memoText
            }
            event.isAllDay = eventData.allDay
            if eventData.allDay == false && eventData.notification == true {
                let alarmEvent = EKAlarm(relativeOffset: 0)
                let alarm5Minute = EKAlarm(relativeOffset: 60 * -5)
                event.alarms = [alarmEvent, alarm5Minute]
            }

            do {
                try eventStore.save(event, span: .thisEvent)
            }
            catch {
                let nserror = error as NSError
                print(nserror)
            }
        }
    }
    
    func getCalendar(id: String) -> EKCalendar? {
        var resultCaledar: EKCalendar? = nil
        for calendar in self.calendars {
            if calendar.calendarIdentifier == id {
                resultCaledar = calendar
                break
            }
        }
        return resultCaledar
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
