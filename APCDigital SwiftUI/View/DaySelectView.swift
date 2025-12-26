//
//  DaySelectView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/16.
//

import SwiftUI

struct DaySelectView: View {
    @State var selectDay: Date = Date()
    @Environment(\.dismiss) var dismiss
    @Environment(DateManagement.self) private var dateManagement
    @Environment(EventManagement.self) private var eventMangement

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("",
                           selection: self.$selectDay,
                           displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .environment(\.calendar, Calendar(identifier: .gregorian).withMondayAsFirstDayOfWeek())
                    .frame(width: 320)
            }
            .navigationTitle("Select Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("Cancel",
                           action: {
                        dismiss()
                    })
                })
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Select",
                           action: {
                        self.dateManagement.setPageStartday(direction: .today, selectday: self.selectDay)
                        self.eventMangement.updateEvents(startDay: self.dateManagement.daysDateComponents[.monday]!,
                                                         endDay: self.dateManagement.daysDateComponents[.sunday]!)
                        self.eventMangement.updateCalendars()
                        dismiss()
                    })
                })
            })
        }
        .onAppear() {
            if let pagestartday = self.dateManagement.pagestartday {
                self.selectDay = pagestartday
            }
        }
    }
}

#Preview {
    DaySelectView()
}
