//
//  EventEditView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/09.
//

import SwiftUI

struct EventEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(EventManagement.self) private var eventMangement
    let point: CGPoint?

    @State var title: String = ""
    @State var location: String = ""
    @State var calendar: String = ""
    @State var allDay: Bool = false
    @State var startDate: Date = Date.now
    @State var endDate: Date = Date.now
    @State var todo: Bool = false
    @State var notification: Bool = false
    @State var memo: Bool = false
    @State var memoText: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: self.$title)
                TextField("Location", text: self.$location)
                Picker("Calendar", selection: self.$calendar, content: {
                    ForEach(self.eventMangement.calendars, id: \.self) { calendar in
                        Text(calendar.title)
                            .tag(calendar.calendarIdentifier)
                    }
                })
                Toggle("All day", isOn: self.$allDay)
                DatePicker("Start Date",
                           selection: self.$startDate,
                           displayedComponents: [.date, .hourAndMinute])
                HStack {
                    Spacer()
                    Button("+0.5H", action: {
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button("+1.0H", action: {
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button("+1.5H", action: {
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button("+2.0H", action: {
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button("+2.5H", action: {
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                    Button("+3.0H", action: {
                    })
                    .buttonStyle(BorderedProminentButtonStyle())
                }
                DatePicker("End Date",
                           selection: self.$endDate,
                           displayedComponents: [.date, .hourAndMinute])
                Toggle("To Do", isOn: self.$todo)
                Toggle("Notification", isOn: self.$notification)
                Toggle("Memo", isOn: self.$memo)
                TextEditor(text: self.$memoText)
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
                    })
                })
            })
        }
        .onAppear() {
            print("%%%%%\(self.point!)")
        }
    }
}

#Preview {
    EventEditView(point: CGPointZero)
        .environment(EventManagement())
}
