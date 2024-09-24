//
//  EventData.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/12.
//

import Foundation
import EventKit
import SwiftUI

@Observable class EventData {
    var title: String = ""
    var location: String = ""
    var calendar: String = ""
    var allDay: Bool = false
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var todo: Bool = false
    var notification: Bool = false
    var notification5Minutes: Bool = false
    var notificationEventTime: Bool = false
    var memo: Bool = false
    var memoText: String = ""
    var eKEvent: EKEvent? = nil
}
