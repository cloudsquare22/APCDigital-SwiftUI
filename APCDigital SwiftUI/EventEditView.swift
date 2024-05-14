//
//  EventEditView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/09.
//

import SwiftUI
import EventKit

struct EventEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(EventManagement.self) private var eventMangement
    @State var eventData: EventData
    
    @State var actionEvent: String = "new"
    let eventDatas: [EKEvent]
    
    let point: CGPoint?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Event", selection: self.$actionEvent, content: {
                        Text("New")
                            .tag("new")
                        ForEach(Array(self.eventDatas.enumerated()), id: \.offset, content: {
                            offset, event in
                            Text(event.title)
                                .tag(String(offset))
                        })
                    })
                    .pickerStyle(.segmented)
                }
                TextField("Title", text: self.$eventData.title)
                TextField("Location", text: self.$eventData.location)
                Picker("Calendar", selection: self.$eventData.calendar, content: {
                    ForEach(self.eventMangement.calendars, id: \.self) { calendar in
                        Text(calendar.title)
                            .tag(calendar.calendarIdentifier)
                    }
                })
                Toggle("All day", isOn: self.$eventData.allDay)
                DatePicker("Start Date",
                           selection: self.$eventData.startDate,
                           displayedComponents: self.eventData.allDay ? [.date] : [.date, .hourAndMinute])
                if self.eventData.allDay == false {
                    HStack {
                        Spacer()
                        Button("+0.5H", action: {
                            self.eventData.endDate = self.eventData.startDate + (60 * 30)
                        })
                        Button("+1.0H", action: {
                            self.eventData.endDate = self.eventData.startDate + (60 * 60)
                        })
                        Button("+1.5H", action: {
                            self.eventData.endDate = self.eventData.startDate + (60 * 90)
                        })
                        Button("+2.0H", action: {
                            self.eventData.endDate = self.eventData.startDate + (60 * 120)
                       })
                        Button("+2.5H", action: {
                            self.eventData.endDate = self.eventData.startDate + (60 * 150)
                        })
                        Button("+3.0H", action: {
                            self.eventData.endDate = self.eventData.startDate + (60 * 180)
                        })
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                DatePicker("End Date",
                           selection: self.$eventData.endDate,
                           displayedComponents: self.eventData.allDay ? [.date] : [.date, .hourAndMinute])
                Toggle("To Do", isOn: self.$eventData.todo)
                Toggle("Notification", isOn: self.$eventData.notification)
                Toggle("Memo", isOn: self.$eventData.memo)
                TextEditor(text: self.$eventData.memoText)
            }
            .navigationTitle("Event")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel", 
                           action: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Save",
                           action: {
                        self.eventMangement.saveEventData(eventData: self.eventData)
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .disabled(self.eventData.title.isEmpty ? true : false)
                })
            })
            .onChange(of: self.eventData.allDay, { old, new in
                if new == true {
                    self.eventData.notification = false
                }
            })
        }
        .onAppear() {
            print("%%%%%\(self.point!)")
        }
    }
}

#Preview {
    EventEditView(eventData: EventData(), eventDatas: [EKEvent()], point: CGPointZero)
        .environment(EventManagement())
}
