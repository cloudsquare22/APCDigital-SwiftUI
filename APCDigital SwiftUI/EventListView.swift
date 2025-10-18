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
    @Environment(\.presentationMode) var presentationMode
    @Binding var dispEventEditView: Bool

    var body: some View {
        NavigationStack {
            List {
                ForEach(eventMangement.events, id: \.eventIdentifier) { event in
                    if self.isDisp(event: event) == true {
                        HStack {
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
                            Spacer()
                            Button(action: {
                                self.eventMangement.operationEventDatas = []
                                let eventData = self.eventMangement.eKEventToEventData(event: event)
                                self.eventMangement.operationEventDatas.append(eventData)
                                self.presentationMode.wrappedValue.dismiss()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                    self.dispEventEditView.toggle()
                                }
                            }, label: {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.title2)
                            })
                            .buttonStyle(.glass)
                        }
                    }
                }
                .onDelete(perform: rowRemove)
            }
            .navigationTitle("Event List")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    func rowRemove(offsets: IndexSet) {
        offsets.forEach { index in
            let ekEvent = self.eventMangement.events[index]
            let eventData = self.eventMangement.eKEventToEventData(event: ekEvent)
            self.eventMangement.removeEventData(eventData: eventData)
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
    EventListView(dispEventEditView: .constant(false))
}
