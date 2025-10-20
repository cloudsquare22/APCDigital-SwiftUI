//
//  HolidayLabelView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/05.
//

import SwiftUI

struct HolidayLabelView: View {
    @Environment(EventManagement.self) private var eventMangement

    fileprivate func createHolidayLabelView(_ weekDay1stMonday: WeekDay1stMonday) -> some View {
        let eventViewData = self.eventMangement.createHolidayViewData(weekDay1stMonday: weekDay1stMonday)
        return HStack {
            Spacer()
            Text(eventViewData.contents)
                .foregroundStyle(Color("Basic Green", bundle: .main))
                .font(Font.system(size: 10.0, weight: .semibold, design: .default))
        }
            .frame(width: eventViewData.width,
                   alignment: .topLeading)
            .offset(x: eventViewData.x,
                    y: eventViewData.y)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(WeekDay1stMonday.allCases, id: \.self) { weekDay1stMonday in
                    self.createHolidayLabelView(weekDay1stMonday)
                }
            }
        }
    }
}

#Preview {
    HolidayLabelView()
        .environment(EventManagement())
}
