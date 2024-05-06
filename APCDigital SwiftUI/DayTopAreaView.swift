//
//  DayLabelsView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/04/30.
//

import SwiftUI

struct DayTopAreaView: View {
    @Environment(DateManagement.self) private var dateManagement
    
    var body: some View {
        DayLabelView()
        RemainingLebelView()
        HolidayLabelView()
        EventsAllDayView()
    }
}

#Preview {
    DayTopAreaView()
        .environment(DateManagement())
        .environment(EventManagement())
}
