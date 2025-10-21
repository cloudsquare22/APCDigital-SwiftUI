//
//  EventEditView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/09.
//

import SwiftUI
import EventKit

struct EventEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(EventManagement.self) private var eventMangement
    
    var eventDatas: [EventData] = []
    
    @State var eventData: EventData = EventData()
    @State var actionEvent: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Event", selection: self.$actionEvent, content: {
                        ForEach(Array(self.eventDatas.enumerated()), id: \.offset, content: {
                            offset, event in
                            Text(event.eKEvent == nil ? "New" : event.title)
                        })
                    })
                    .pickerStyle(.segmented)
                    .onChange(of: self.actionEvent, { old, new in
                        print(old)
                        print(new)
                        print(self.eventDatas[new].title)
                        self.eventData = self.eventDatas[new]
                    })
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
                if self.eventData.notification == true {
                    HStack {
                        Spacer()
                        Text("5min before")
                        Toggle("5minutes before", isOn: self.$eventData.notification5Minutes)
                            .labelsHidden()
                        Text("Event time")
                        Toggle("Event Time", isOn: self.$eventData.notificationEventTime)
                            .labelsHidden()
                    }
                }
                Toggle("Memo", isOn: self.$eventData.memo)
                TextEditor(text: self.$eventData.memoText)
                    .frame(height: 100)
            }
            .navigationTitle("Event")
            .toolbarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel", 
                           action: {
                        dismiss()
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(self.eventData.eKEvent == nil ? "Create" : "Save",
                           action: {
                        self.eventMangement.saveEventData(eventData: self.eventData)
                        dismiss()
                    })
                    .disabled(self.eventData.title.isEmpty ? true : false)
                })
                ToolbarItem(placement: .secondaryAction, content: {
                    Button("Remove",
                           action: {
                        self.eventMangement.removeEventData(eventData: self.eventData)
                        dismiss()
                    })
                    .disabled(self.eventData.eKEvent == nil ? true : false)
                })
            })
            .onChange(of: self.eventData.allDay, { old, new in
                if new == true {
                    self.eventData.notification = false
                }
            })
        }
        .onAppear() {
            if self.eventDatas.isEmpty == false {
                self.eventData = self.eventDatas[0]
                self.actionEvent = 0
            }
        }
    }
}

#Preview {
    EventEditView(eventDatas: [EventData()])
        .environment(EventManagement())
}
