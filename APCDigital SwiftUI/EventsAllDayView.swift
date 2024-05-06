//
//  EventsAllDayView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/05.
//

import SwiftUI

struct EventsAllDayView: View {
    @Environment(EventManagement.self) private var eventMangement

    fileprivate func createEventAllDayView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let eventViewData = self.eventMangement.createAllDayEventViewData(weekDay1stMonday: weekDay1stMonday)
        return Text(eventViewData.contents)
            .lineLimit(5)
            .font(Font.system(size: 10.0, weight: .medium, design: .default))
            .frame(width: eventViewData.width,
                   alignment: .topLeading)
            .offset(x: eventViewData.x,
                    y: eventViewData.y)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                    createEventAllDayView(weekDay1stMonday)
                }
            }
        }
    }
}

#Preview {
    EventsAllDayView()
        .environment(EventManagement())
}
