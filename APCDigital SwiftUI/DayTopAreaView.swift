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
        ForEach(WeekDay1stMonday.allCases, id: \.self) { weekday in
            if let day = self.dateManagement.days[weekday] {
                Text("\(day)")
                    .foregroundStyle(Color("Basic Green", bundle: .main))
                    .font(Font.system(size: 24.0, weight: .semibold))
                    .offset(x: self.dateManagement.getDayLebelPosition(weekDay: weekday).x,
                            y: self.dateManagement.getDayLebelPosition(weekDay: weekday).y)
                Text("\(self.dateManagement.getRemainingLebel(weekDay: weekday).contents)")
                    .foregroundStyle(Color("Basic Green", bundle: .main))
                    .font(Font.system(size: 10.0, weight: .semibold))
                    .offset(x: self.dateManagement.getRemainingLebel(weekDay: weekday).x,
                            y: self.dateManagement.getRemainingLebel(weekDay: weekday).y)
            }
        }
    }
}

#Preview {
    DayTopAreaView()
        .environment(DateManagement())
}
