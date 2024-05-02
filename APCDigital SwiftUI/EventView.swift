//
//  EventView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/02.
//

import SwiftUI

struct EventView: View {
    @Environment(EventManagement.self) private var eventMangement

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(self.eventMangement.events, id: \.self) { event in
                    if event.calendar.isEqual(self.eventMangement.calendars[5]) == true {
                        Text("\(event.title!)")
                            .font(Font.system(size: 9.0, weight: .medium, design: .default))
                            .frame(width: 142, height: 23, alignment: .topLeading)
                            .border(.black, width: 1)
                            .background(.cyan.opacity(0.1))
                            .offset(x: 54,
                                    y: self.eventMangement.eventPosition(event: event).y)
//                        Rectangle()
//                            .fill(.cyan.opacity(0.1))
//                            .frame(width: 100, height: 100, alignment: .topLeading)
//                            .overlay(content: {
//                                Text("\(event.title!)")
//                                    .offset(x: 0, y: 0)
//                            })
//                            .offset(x: 0, y: 0)
                    }
                }
            }
        }
        .onAppear() {
            print(self.eventMangement.events.count)
        }
    }
}

#Preview {
    EventView()
        .environment(EventManagement())
}
