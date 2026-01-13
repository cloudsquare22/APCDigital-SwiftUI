//
//  CalendarSelectView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2026/01/11.
//

import SwiftUI

struct CalendarSelectView: View {
    @Environment(EventManagement.self) private var eventMangement
    @State var selectedCalendars: [String]

    var body: some View {
        NavigationStack {
            List(self.eventMangement.allCalendars(), id: \.calendarIdentifier) { calendar in
                HStack {
                    if self.selectedCalendars.contains(calendar.calendarIdentifier) == true {
                        Image(systemName: "checkmark.square")
                            .onTapGesture {
                                self.selectedCalendars.remove(at: self.selectedCalendars.firstIndex(of: calendar.calendarIdentifier)!)
                            }
                    }
                    else {
                        Image(systemName: "square")
                            .onTapGesture {
                                self.selectedCalendars.append(calendar.calendarIdentifier)
                            }
                    }
                    Text(calendar.title)
                }
            }
            .navigationTitle("Calendar Select")
        }
    }
}

#Preview {
    CalendarSelectView(selectedCalendars: [])
}
