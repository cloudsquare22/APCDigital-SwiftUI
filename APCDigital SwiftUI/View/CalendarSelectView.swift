//
//  CalendarSelectView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2026/01/11.
//

import SwiftUI

struct CalendarSelectView: View {
    @Environment(EventManagement.self) private var eventMangement

    var body: some View {
        NavigationStack {
            List(self.eventMangement.allCalendars(), id: \.calendarIdentifier) { calendar in
                Text(calendar.title)
            }
        }
    }
}

#Preview {
    CalendarSelectView()
}
