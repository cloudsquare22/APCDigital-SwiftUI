//
//  SettingView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2026/01/01.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(EventManagement.self) private var eventMangement
    @State var moveSymbols: String = ""
    @State var eventBackgroundColor: Bool = true
    @State var holidayCalendarId: String = ""

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Label("Move symbols", systemImage: "car")
                    Spacer()
                    TextField("Move symbols", text: self.$moveSymbols)
                        .textFieldStyle(.roundedBorder)
                }
                .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                        0
                    })
                HStack {
                    Toggle("Evnet Background Color",
                           systemImage: self.eventBackgroundColor == true ? "paintbrush.fill" : "paintbrush",
                           isOn: self.$eventBackgroundColor)
                }
                .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                        0
                    })
                Section("Calendar") {
                    NavigationLink(destination: CalendarSelectView(selectedCalendars: self.eventMangement.dispCalendarIds), label: {
                        Label("Disp Calendar Selects", systemImage: "calendar.badge.checkmark")
                    })
                    Picker("Holiday Calendar Select", systemImage: "calendar.badge", selection: self.$holidayCalendarId, content: {
                        Text("")
                            .tag("")
                        ForEach(self.eventMangement.allCalendars(), id: \.calendarIdentifier) { calendar in
                            Text("\(calendar.title)")
                                .tag(calendar.calendarIdentifier)
                        }
                    })
                }
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel",
                           action: {
                        dismiss()
                    })
                })
            })
        }
        .onChange(of: self.holidayCalendarId) { old, new in
            self.eventMangement.holidayCalendarId = new
            UserDefaults.standard.set(new, forKey: "holidayCalendarId")
        }
        .onAppear {
            self.holidayCalendarId = self.eventMangement.holidayCalendarId
        }        
    }
}

#Preview {
    SettingView()
}
