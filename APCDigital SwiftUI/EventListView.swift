//
//  EventListView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2025/10/18.
//

import SwiftUI
import EventKit

struct EventListView: View {
    @Environment(EventManagement.self) private var eventMangement

    var body: some View {
        NavigationStack {
            List(eventMangement.events, id: \.eventIdentifier) { event in
                if self.isDisp(event: event) == true {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(self.eventMangement.cgToUIColor(cgColor: event.calendar.cgColor,
                                                                                 alpha: 1.0))
                            if event.isAllDay == true {
                                Text("\(event.startDate.formatted(.dateTime.year().month().day()))")
                            }
                            else {
                                Text("\(event.startDate.formatted(.dateTime.year().month().day().hour().minute()))〜\(event.endDate.formatted(.dateTime.hour().minute()))")
                            }
                        }
                        Text(event.title)
                    }
                }
            }
            .navigationTitle("Event List")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    func isDisp(event: EKEvent) -> Bool {
        var disp = true
        if let calendar = event.calendar, calendar.title == "日本の祝日" {
            disp = false
        }
        else if let calendar = event.calendar, calendar.title == "誕生日" {
            disp = false
        }
        else if let calendar = event.calendar, calendar.type != .calDAV {
            disp = false
        }
        return disp
    }
}

#Preview {
    EventListView()
}
